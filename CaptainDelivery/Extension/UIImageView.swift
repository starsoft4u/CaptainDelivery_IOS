//
//  UIImageView.swift
//  Homeworker
//
//  Created by raptor on 2018/10/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor?) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
