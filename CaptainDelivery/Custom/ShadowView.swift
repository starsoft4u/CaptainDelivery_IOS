//
//  ShadowView.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    @IBInspectable var topBottomOnly: Bool = false

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()

            if topBottomOnly {
                shadowLayer.path = UIBezierPath(rect: CGRect(x: 0, y: -3, width: bounds.width, height: bounds.height + 6)).cgPath
            } else {
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            }

            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 2
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.fillColor = backgroundColor?.cgColor

            layer.insertSublayer(shadowLayer, at: 0)
            
        } else {
            
            if topBottomOnly {
                shadowLayer.path = UIBezierPath(rect: CGRect(x: 0, y: -3, width: bounds.width, height: bounds.height + 6)).cgPath
            } else {
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            }

            shadowLayer.shadowPath = shadowLayer.path
        }
    }
}
