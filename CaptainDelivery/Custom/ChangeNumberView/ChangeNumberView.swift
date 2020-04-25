//
//  ChnageNumberView.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/29.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import NKVPhonePicker
import SwiftEntryKit

class ChangeNumberView: UIView {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var oldPhoneNumberView: NKVPhonePickerTextField!
    @IBOutlet weak var newPhoneNumberView: NKVPhonePickerTextField!

    var action: ((_ old: NKVPhonePickerTextField, _ new: NKVPhonePickerTextField) -> Void)?

    func error(_ message: String, for textfield: NKVPhonePickerTextField? = nil) {
        errorLabel.text = message
        errorLabel.isHidden = false
//        UIView.animate(withDuration: 2, animations: { }, completion: { _ in self.errorLabel.isHidden = true })
        textfield?.becomeFirstResponder()
    }

    @IBAction func onSubmitAction(_ sender: Any) {
        action?(oldPhoneNumberView, newPhoneNumberView)
    }

    @IBAction func onCancelAction(_ sender: Any) {
        oldPhoneNumberView.resignFirstResponder()
        newPhoneNumberView.resignFirstResponder()
        SwiftEntryKit.dismiss()
    }
}
