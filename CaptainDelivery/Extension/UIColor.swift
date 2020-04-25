//
//  UIColor+RGB.swift
//  ShopizQatar
//
//  Created by raptor on 2018/9/14.
//  Copyright © 2018 raptor. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    open class var green: UIColor { return UIColor(rgb: 0x4CAF50) }
    open class var orange: UIColor { return UIColor(rgb: 0xE65A49) }
    open class var lightGrey: UIColor { return UIColor(rgb: 0xf7f8fa) }
    open class var normalTextColor: UIColor { return UIColor(rgb: 0x1c252a) }
    open class var primaryColor: UIColor { return UIColor(rgb: 0xDD4339) }
}

