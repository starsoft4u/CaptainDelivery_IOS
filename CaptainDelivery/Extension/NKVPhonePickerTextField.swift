//
//  NKVPhonePickerTextField.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/29.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import Foundation
import NKVPhonePicker

extension NKVPhonePickerTextField {
    var rawPhoneNumber: String {
        guard let theCode = code, let theNumber = self.phoneNumber,
            theNumber.starts(with: theCode), theNumber.count > theCode.count else {
                return ""
        }

        return String(theNumber.dropFirst(theCode.count))
    }

}
