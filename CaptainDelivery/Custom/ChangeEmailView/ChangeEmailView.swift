//
//  ChnageNumberView.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/29.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftEntryKit

class ChangeEmailView: UIView {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var oldEmailView: SkyFloatingLabelTextField!
    @IBOutlet weak var newEmailView: SkyFloatingLabelTextField!

    var action: ((_ old: SkyFloatingLabelTextField, _ new: SkyFloatingLabelTextField) -> Void)?

    func error(_ message: String, for textfield: SkyFloatingLabelTextField? = nil) {
        errorLabel.text = message
        errorLabel.isHidden = false
        textfield?.becomeFirstResponder()
    }

    @IBAction func onSubmitAction(_ sender: Any) {
        action?(oldEmailView, newEmailView)
    }

    @IBAction func onCancelAction(_ sender: Any) {
        oldEmailView.resignFirstResponder()
        newEmailView.resignFirstResponder()
        SwiftEntryKit.dismiss()
    }
}
