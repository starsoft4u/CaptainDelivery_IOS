//
//  AlertView.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/29.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import SwiftEntryKit

class AlertView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var onOkay: (() -> Void)?
    var onCancel: (() -> Void)?

    func setup(title: String?, message: String?, okButton: String? = "OK", cancelButton: String? = "CANCEL") {
        if let title = title {
            titleLabel.text = title
        } else {
            titleLabel.isHidden = true
        }

        if let message = message {
            messageLabel.text = message
        } else {
            messageLabel.isHidden = true
        }

        if let ok = okButton {
            self.okButton.setTitle(ok, for: .normal)
        } else {
            self.okButton.isHidden = true
        }

        if let cancel = cancelButton {
            self.cancelButton.setTitle(cancel, for: .normal)
        } else {
            self.cancelButton.isHidden = true
        }
    }

    @IBAction func onOkayAction(_ sender: Any) {
        onOkay?()
        SwiftEntryKit.dismiss()
    }

    @IBAction func onCancelAction(_ sender: Any) {
        onCancel?()
        SwiftEntryKit.dismiss()
    }

}
