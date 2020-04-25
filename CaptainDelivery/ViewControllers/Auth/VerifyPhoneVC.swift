//
//  VerifyPhoneVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/10.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftValidators
import Networking
import SwiftyJSON
import SwiftEntryKit
import NKVPhonePicker

class VerifyPhoneVC: CommonVC {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var codeView: SkyFloatingLabelTextField!

    var countryCode: String?
    var phoneNumber: String?
    var net: Networking!

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()

        guard let countryCode = countryCode, let phoneNumber = phoneNumber else {
            fail("Invalid phone number")
            return
        }

        descriptionLabel.text = "We are unable to auto-verify your mobile number.\nPlease enter the code tested to +\(countryCode)\(phoneNumber)"

        net = Networking(baseURL: Constants.Url.twilioBase)
        net.setAuthorizationHeader(headerKey: "X-Authy-API-Key", headerValue: Constants.Url.twilioKey)

        requestVerificationCode()
    }

    fileprivate func requestVerificationCode(showResult: Bool = false) {
        let params: [String: Any] = [
            "via": "sms",
            "country_code": countryCode!,
            "phone_number": phoneNumber!,
        ]
        let url = "/protected/json/phones/verification/start"
        net.post(url, parameterType: .formURLEncoded, parameters: params) { result in
            switch result {
            case .success(let res):
                let json = JSON(res.dictionaryBody)
                if json["success"].boolValue {
                    if showResult {
                        self.success(json["message"].stringValue)
                    }
                } else {
                    self.fail(json["message"].string ?? "Failed to send verificatino code.\nPlease try again later.")
                }

            case .failure(let res):
                self.fail(res.error.localizedDescription)
            }
        }
    }

    fileprivate func updateVerificationState() {
        let params: [String: Any] = [
            "phone": phoneNumber!,
            "phone_verify_code": codeView.text!,
        ]
        post(url: "phone_verify", params: params) { res in
            self.success(res["message"].stringValue)

            let vc = AppStoryboard.Main.viewController(UserInfoVC.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func onSubmitAction(_ sender: Any) {
        if Validator.isEmpty().apply(codeView.text) {
            fail("Please input OPT", for: codeView)

        } else {
            let params: [String: Any] = [
                "country_code": countryCode!,
                "phone_number": phoneNumber!,
                "verification_code": codeView.text!,
            ]

            startAnimating()
            net.get("/protected/json/phones/verification/check", parameters: params) { result in
                switch result {
                case .success(let res):
                    let json = JSON(res.dictionaryBody)
                    if json["success"].boolValue {
                        self.success(json["message"].stringValue)
                        self.updateVerificationState()
                    } else {
                        self.stopAnimating()
                        self.fail("Invalid verificatino code")
                    }

                case .failure(let res):
                    self.stopAnimating()
                    self.fail(res.error.localizedDescription)
                }
            }

        }
    }

    @IBAction func onResendCodeAction(_ sender: Any) {
        requestVerificationCode(showResult: true)
    }

    @IBAction func onChangeNumberAction(_ sender: Any) {
        let view: ChangeNumberView = .loadViewFromNib()
        view.oldPhoneNumberView.phonePickerDelegate = self
        view.oldPhoneNumberView.country = Country.country(for: NKVSource(phoneExtension: countryCode!))
        view.oldPhoneNumberView.text = "\(countryCode!)\(phoneNumber!)"
        view.action = { old, new in
            if Validator.isEmpty().apply(old.rawPhoneNumber) {
                view.error("Please input the old phone number")
            } else if Validator.isEmpty().apply(new.rawPhoneNumber) {
                view.error("Please input the new phone number")
            } else if old.phoneNumber == new.phoneNumber {
                view.error("Please input the different phone number")
            } else {
                old.resignFirstResponder()
                new.resignFirstResponder()

                let params: [String: Any] = [
                    "user_id": Defaults.userId.value,
                    "new_phone": view.newPhoneNumberView.rawPhoneNumber,
                    "country_code": view.newPhoneNumberView.code!,
                ]

                self.post(url: "change_phonenumber", params: params, indicator: false, completion: { res in
                    Defaults.userCountryCode.value = view.newPhoneNumberView.code
                    Defaults.userPhoneNumber.value = view.newPhoneNumberView.rawPhoneNumber

                    self.requestVerificationCode(showResult: true)
                })

                SwiftEntryKit.dismiss()
            }
        }
        dialog(view)
    }
}
