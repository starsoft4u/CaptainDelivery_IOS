//
//  DatePicker.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/31.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import SwiftEntryKit

class DatePickerView: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!

    var datePicked: ((_ date: Date) -> Void)?

    @IBAction func onDoneAction(_ sender: Any) {
        datePicked?(datePicker.date)
        SwiftEntryKit.dismiss()
    }

    @IBAction func onCancelAction(_ sender: Any) {
        SwiftEntryKit.dismiss()
    }
}
