//
//  SignUpVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/10.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NKVPhonePicker
import BEMCheckBox
import SwiftValidators
import SwiftyJSON
import GoogleSignIn
import FacebookCore
import FacebookLogin

class SignUpVC: CommonVC {
    @IBOutlet weak var userNameView: SkyFloatingLabelTextField!
    @IBOutlet weak var emailView: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordView: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberView: NKVPhonePickerTextField!
    @IBOutlet weak var driverCheckbox: BEMCheckBox!
    @IBOutlet weak var customerCheckbox: BEMCheckBox!

    var role: BEMCheckBoxGroup!
    var isChangingPhoneNumber = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Phone number
        phoneNumberView.phonePickerDelegate = self

        // Radio buttons
        role = BEMCheckBoxGroup(checkBoxes: [driverCheckbox, customerCheckbox])
        role.selectedCheckBox = self.driverCheckbox
        role.mustHaveSelection = true

        // "OR" rectangle
        view.viewWithTag(11)?.transform = CGAffineTransform(rotationAngle: .pi / 4)
    }

    fileprivate func signUp(
        name: String,
        email: String,
        countryCode: String?,
        phoneNumber: String?,
        password: String?,
        fID: String?,
        fName: String?,
        gID: String?,
        gMail: String?) {

        var loginMethod: Defaults.LoginMethod = .normal
        var params: [String: Any] = [
            "name": name,
            "email": email,
            "auth": driverCheckbox.on ? 1 : 0,
            "token": Defaults.deviceToken.value,
        ]
        if let password = password {
            params["password"] = password
        } else {
            params["email_verify_status"] = 1
        }
        if let countryCode = countryCode {
            params["country_code"] = countryCode
        }
        if let phoneNumber = phoneNumber {
            params["phone"] = phoneNumber
        }
        if let fID = fID {
            params["f_id"] = fID
            loginMethod = .facebook
        }
        if let fName = fName {
            params["f_name"] = fName
        }
        if let gID = gID {
            params["g_id"] = gID
            loginMethod = .google
        }
        if let gMail = gMail {
            params["g_email"] = gMail
        }
        post(url: "register_request", params: params) { res in
            Defaults.loginMethod.value = loginMethod.rawValue
            Defaults.userId.value = res["user_id"].intValue
            Defaults.userName.value = name
            Defaults.userEmail.value = email
            Defaults.userCountryCode.value = countryCode ?? ""
            Defaults.userPhoneNumber.value = phoneNumber ?? ""
            Defaults.isDriver.value = self.driverCheckbox.on

            if loginMethod == .normal {
                // Verify email
                let vc = AppStoryboard.Main.viewController(VerifyEmailVC.self)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Verify phone
                let vc = AppStoryboard.Main.viewController(VerifyPhoneVC.self)
                vc.countryCode = Defaults.userCountryCode.value
                vc.phoneNumber = Defaults.userPhoneNumber.value
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }


    @IBAction func onNextAction(_ sender: Any) {
        if Validator.isEmpty().apply(userNameView.text) {
            fail("Please input the username", for: userNameView)
        } else if Validator.isEmpty().apply(emailView.text) {
            fail("Please input the email address", for: emailView)
        } else if !Validator.isEmail().apply(emailView.text) {
            fail("Invalid email address", for: emailView)
        } else if Validator.isEmpty().apply(passwordView.text) {
            fail("Please input the password", for: passwordView)
        } else if Validator.isEmpty().apply(phoneNumberView.rawPhoneNumber) {
            fail("Please input the phone number", for: phoneNumberView)
        } else {
            signUp(
                name: userNameView.text!,
                email: emailView.text!,
                countryCode: phoneNumberView.code!,
                phoneNumber: phoneNumberView.rawPhoneNumber,
                password: passwordView.text!,
                fID: nil,
                fName: nil,
                gID: nil,
                gMail: nil
            )
        }
    }

    @IBAction func onGoogleAction(_ sender: Any) {
        if let lastUser = GIDSignIn.sharedInstance().currentUser {
            signUp(
                name: lastUser.profile.name,
                email: lastUser.profile.email,
                countryCode: nil,
                phoneNumber: nil,
                password: nil,
                fID: nil,
                fName: nil,
                gID: lastUser.userID,
                gMail: lastUser.profile.email
            )
        } else {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
        }
    }

    @IBAction func onFacebookAction(_ sender: Any) {
        if let accessToken = AccessToken.current {
            requestFacebookProfile(accessToken: accessToken)
        } else {
            LoginManager().logIn(readPermissions: [.publicProfile, .email], viewController: self) { [unowned self] result in
                switch result {
                case .failed(let error):
                    self.fail(error.localizedDescription)

                case .cancelled:
                    self.fail("User cancelled login")

                case .success(_, _, let accessToken):
                    print("Facebook logged in successfully: \(accessToken)")
                    self.requestFacebookProfile(accessToken: accessToken)
                }
            }
        }
    }

    fileprivate func requestFacebookProfile(accessToken: AccessToken) {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name"], accessToken: accessToken, httpMethod: .GET)

        connection.add(request) { [unowned self] response, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")

                let json = JSON(response.dictionaryValue!)
                self.signUp(
                    name: json["name"].stringValue,
                    email: json["email"].stringValue,
                    countryCode: nil,
                    phoneNumber: nil,
                    password: nil,
                    fID: json["id"].string,
                    fName: json["name"].string,
                    gID: nil,
                    gMail: nil
                )
                LoginManager().logOut()

            case .failed(let error):
                print("Graph Request Failed (/me) : \(error.localizedDescription)")
                self.fail("Facebook login failed. Please try again.")
            }
        }
        connection.start()
    }
}

extension SignUpVC: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            fail(error.localizedDescription)
            return
        }

        print("Google signin successfully: \(user!)")

        signUp(
            name: user.profile.name,
            email: user.profile.email,
            countryCode: nil,
            phoneNumber: nil,
            password: nil,
            fID: nil,
            fName: nil,
            gID: user.userID,
            gMail: user.profile.email
        )

        GIDSignIn.sharedInstance().signOut()
    }
}
