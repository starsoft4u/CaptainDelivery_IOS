//
//  VehicleTypeView.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/30.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit

enum VehicleType: Int {
    case micro = 1, mini, sedan
}

class VehicleTypeView: ShadowView {
    @IBOutlet weak var vehicleButton: UIButton!
    @IBOutlet weak var vehicleButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var vehicleButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!

    var onTapped: ((_ selected: Bool) -> Void)?

    func setup(for type: VehicleType) {
        switch type {
        case .micro:
            vehicleButton.setImage(#imageLiteral(resourceName: "ic_vehicle_micro.png"), for: .normal)
            vehicleButtonWidth.constant = 33
            vehicleButtonHeight.constant = 16
            titleLabel.text = "CAPTAIN DELIVERY Micro"
            descriptionLabel.text = "You are a commercially insured driver. Your vehicle is a mid-size or full size vehicle that comfortably seats 4 passengers or more."
            detailLabel.text = "02 Max\nPerson"

        case .mini:
            vehicleButton.setImage(#imageLiteral(resourceName: "ic_vehicle_mini.png"), for: .normal)
            vehicleButtonWidth.constant = 55
            vehicleButtonHeight.constant = 20
            titleLabel.text = "CAPTAIN DELIVERY Mini"
            descriptionLabel.text = "You are a commercially insured driver. Your vehicle is a mid-size or full size vehicle that comfortably seats 4 passengers or more."
            detailLabel.text = "04 Max\nPerson"

        case .sedan:
            vehicleButton.setImage(#imageLiteral(resourceName: "ic_vehicle_sedan.png"), for: .normal)
            vehicleButtonWidth.constant = 55
            vehicleButtonHeight.constant = 20
            titleLabel.text = "CAPTAIN DELIVERY Sedan"
            descriptionLabel.text = "You are a commercially insured driver. Your vehicle is a mid-size or full size vehicle that comfortably seats 4 passengers or more."
            detailLabel.text = "04 Max\nPerson"
        }

        collapse()
    }

    func collapse() {
        toggleButton.tag = 0
        self.vehicleButton.tintColor = .darkGray
        self.separatorView.isHidden = true
        self.descriptionView.isHidden = true
        self.checkImage.isHidden = true
    }

    func expand() {
        toggleButton.tag = 1
        self.vehicleButton.tintColor = .primaryColor
        self.separatorView.isHidden = false
        self.descriptionView.isHidden = false
        self.checkImage.isHidden = false
    }

    @IBAction func onToggleAction(_ sender: UIButton) {
        if sender.tag == 0 {
            expand()
        } else {
            collapse()
        }
        onTapped?(sender.tag == 1)
    }
}
