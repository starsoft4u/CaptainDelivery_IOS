//
//  LoginVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/10.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import BEMCheckBox
import SwiftyAttributes
import SwiftValidators
import GoogleSignIn
import FacebookCore
import FacebookLogin
import SwiftyJSON


class LoginVC: CommonVC {
    @IBOutlet weak var phoneOrEmailView: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordView: SkyFloatingLabelTextField!
    @IBOutlet weak var driverCheckbox: BEMCheckBox!
    @IBOutlet weak var customerCheckbox: BEMCheckBox!

    var role: BEMCheckBoxGroup!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Radio buttons
        role = BEMCheckBoxGroup(checkBoxes: [driverCheckbox, customerCheckbox])
        role.selectedCheckBox = self.driverCheckbox
        role.mustHaveSelection = true

        // "OR" rectangle
        view.viewWithTag(11)?.transform = CGAffineTransform(rotationAngle: .pi / 4)
        
        /////////////////////////
        // Check login
    }


    fileprivate func login(email: String, password: String, loginType: String) {
        let params: [String: Any] = [
            "user": email,
            "password": password,
            "token": Defaults.deviceToken.value,
        ]
        post(url: "login_request", params: params) { res in
            let json = res["data"]

            if json["auth"].intValue == "1" {

                // Driver
                guard self.driverCheckbox.on else {
                    self.fail("Your account is for Driver, not Customer.")
                    return
                }

                //////////////////////
//                guard json["is_active"].intValue > 0 else {
//                    self.fail("Your account must be activated")
//                    return
//                }
                
                if json["is_active"].intValue > 0 {
                    self.success(json["message"].stringValue)
                }

                Defaults.isDriver.value = true
                Defaults.driverId.value = json["ext_id"].intValue

            } else {

                // Customer
                guard self.customerCheckbox.on else {
                    self.fail("Your account is for Customer, not Driver.")
                    return
                }

                self.success(json["message"].stringValue)

                Defaults.isDriver.value = false
                Defaults.customerId.value = json["ext_id"].intValue
            }

            Defaults.userId.value = json["user_id"].intValue
            Defaults.userName.value = json["name"].string
            Defaults.userEmail.value = json["email"].string
            Defaults.userCountryCode.value = json["country_code"].string
            Defaults.userPhoneNumber.value = json["phone"].string
            Defaults.userPhotoUrl.value = json["image"].string
            Defaults.userCountry.value = json["country"].string
            Defaults.userCity.value = json["city"].string
            Defaults.userStreet.value = json["region_street"].string
            Defaults.userLat.value = json["lat"].doubleValue
            Defaults.userLng.value = json["lng"].doubleValue
            Defaults.userRate.value = json["rate"].doubleValue
            Defaults.loginMethod.value = loginType

            var viewController: UIViewController?
//            if !json["email_verify_status"].boolValue {
//                // Email verify
//                viewController = AppStoryboard.Main.viewController(VerifyEmailVC.self)
//
//            } else if !json["phone_verify_status"].boolValue {
//                // Phone verify
//                let vc = AppStoryboard.Main.viewController(VerifyPhoneVC.self)
//                vc.countryCode = Defaults.userCountryCode.value
//                vc.phoneNumber = Defaults.userPhoneNumber.value
//                viewController = vc
//
//            } else if json["signup_step"].stringValue.isEmpty {
//                // Personal infomation
//                viewController = AppStoryboard.Main.viewController(UserInfoVC.self)
//
//            } else if json["signup_step"].string == "personal_information" {
//
//                if Defaults.isDriver.value {
//                    // Driver vehicle detail
//                    viewController = AppStoryboard.Vehicle.viewController(VehicleDetailVC.self)
//                } else {
//                    // Customer main
//
//                }
//
//            } else if json["signup_step"].string == "vehicle_details" {
//                // Driver vehicle type
//
//            } else if json["signup_step"].string == "vehicle_type" {
//                // Driver vehicle ownership
//
//            } else if json["signup_step"].string == "vehicle_ownership" {
//                // Driver driving license
//
//            } else if json["signup_step"].string == "driving_license" {
//                // Driver main
//
//            } else {
//                if Defaults.isDriver.value {
//                    // Driver main
//                    viewController = AppStoryboard.Vehicle.viewController(MainVC.self)
//                } else {
//                    // Customer main
//
//                }
//            }

            viewController = MainVC()
            if let vc = viewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }


    @IBAction func onLoginAction(_ sender: Any) {
        if Validator.isEmpty().apply(phoneOrEmailView.text) {
            fail("Please input phone number or email address", for: phoneOrEmailView)
        } else if !Validator.isEmail().apply(phoneOrEmailView.text), !Validator.isPhone(Phone.en_US).apply(phoneOrEmailView.text) {
            fail("Invalid phone number or email address", for: phoneOrEmailView)
        } else if Validator.isEmpty().apply(passwordView.text) {
            fail("Please input the password", for: passwordView)
        } else {
            login(email: phoneOrEmailView.text!, password: passwordView.text!, loginType: "normal")
        }
    }

    @IBAction func onGoogleAction(_ sender: Any) {
        if let lastUser = GIDSignIn.sharedInstance().currentUser {
            login(email: lastUser.profile.email, password: lastUser.userID, loginType: "google")
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
                self.login(email: json["email"].stringValue, password: json["id"].stringValue, loginType: "facebook")
                LoginManager().logOut()

            case .failed(let error):
                print("Graph Request Failed (/me) : \(error.localizedDescription)")
                self.fail("Facebook login failed. Please try again.")
            }
        }
        connection.start()
    }
}

extension LoginVC: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            fail(error.localizedDescription)
            return
        }

        print("Google signin successfully: \(user!)")

        login(email: user.profile.email, password: user.userID, loginType: "google")

        GIDSignIn.sharedInstance().signOut()
    }
}
