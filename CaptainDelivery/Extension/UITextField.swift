//
//  UITextField.swift
//  ShopizQatar
//
//  Created by raptor on 2018/9/14.
//  Copyright © 2018 raptor. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            if let hint = placeholder, let color = newValue {
                attributedPlaceholder = NSAttributedString(string: hint, attributes: [.foregroundColor: color])
            }
        }
    }
}
