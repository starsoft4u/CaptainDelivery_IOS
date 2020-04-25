//
//  VerifyEmailVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/28.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import PinCodeTextField
import SwiftValidators
import SwiftEntryKit

class VerifyEmailVC: CommonVC {
    @IBOutlet weak var codeView: PinCodeTextField!
    @IBOutlet weak var expireLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()

        requestVerificationCode()
    }

    fileprivate func requestVerificationCode(showResult: Bool = false) {
        guard let email = Defaults.userEmail.value else {
            fail("Invalid email address")
            return
        }

        post(url: "verify_request", params: ["email": email], indicator: showResult) { res in
            if showResult {
                self.success(res["message"].stringValue)
            }
        }
    }

    @IBAction func onSubmitAction(_ sender: Any) {
        guard let email = Defaults.userEmail.value else {
            fail("Invalid email address")
            return
        }

        if Validator.isEmpty().apply(codeView.text) {
            fail("Please input code", for: codeView)
        } else if !Validator.exactLength(4).apply(codeView.text) {
            fail("Invalid verification code", for: codeView)
        } else {
            let params: [String: Any] = [
                "email": email,
                "email_verify_code": codeView.text!,
            ]
            post(url: "email_verify", params: params) { res in
                self.success(res["message"].stringValue)

                let vc = AppStoryboard.Main.viewController(VerifyPhoneVC.self)
                vc.countryCode = Defaults.userCountryCode.value
                vc.phoneNumber = Defaults.userPhoneNumber.value
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    @IBAction func onResendCodeAction(_ sender: Any) {
        requestVerificationCode(showResult: true)
    }

    @IBAction func onChangeEmailAction(_ sender: Any) {
        let view: ChangeEmailView = .loadViewFromNib()
        view.oldEmailView.text = Defaults.userEmail.value
        view.action = { old, new in
            if Validator.isEmpty().apply(old.text) {
                view.error("Please input the old email address")
            } else if !Validator.isEmail().apply(old.text) {
                view.error("Invalid email address")
            } else if Validator.isEmpty().apply(new.text) {
                view.error("Please input the new email")
            } else if !Validator.isEmail().apply(new.text) {
                view.error("Invalid email address")
            } else if old.text == new.text {
                view.error("Please input the different email address")
            } else {
                old.resignFirstResponder()
                new.resignFirstResponder()

                let params: [String: Any] = [
                    "user_id": Defaults.userId.value,
                    "old_email": old.text!,
                    "new_email": new.text!,
                ]

                self.post(url: "change_phonenumber", params: params, indicator: false, completion: { res in
                    Defaults.userEmail.value = new.text
                    self.requestVerificationCode(showResult: true)
                })

                SwiftEntryKit.dismiss()
            }
        }
        dialog(view)
    }
}
