//
//  VehicleTypeVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/30.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit

class VehicleTypeVC: CommonVC {
    @IBOutlet weak var stackView: UIStackView!

    var microView: VehicleTypeView!
    var miniView: VehicleTypeView!
    var sedanView: VehicleTypeView!

    var selectedType: VehicleType?

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()

        microView = VehicleTypeView.loadViewFromNib()
        microView.setup(for: .micro)
        microView.onTapped = { selected in
            if (selected) {
                self.selectedType = .micro
                self.miniView.collapse()
                self.sedanView.collapse()
            } else {
                self.selectedType = nil
            }
        }
        stackView.addArrangedSubview(microView)

        miniView = VehicleTypeView.loadViewFromNib()
        miniView.setup(for: .mini)
        miniView.onTapped = { selected in
            if (selected) {
                self.selectedType = .mini
                self.microView.collapse()
                self.sedanView.collapse()
            } else {
                self.selectedType = nil
            }
        }
        stackView.addArrangedSubview(miniView)

        sedanView = VehicleTypeView.loadViewFromNib()
        sedanView.setup(for: .sedan)
        sedanView.onTapped = { selected in
            if (selected) {
                self.selectedType = .sedan
                self.microView.collapse()
                self.miniView.collapse()
            } else {
                self.selectedType = nil
            }
        }
        stackView.addArrangedSubview(sedanView)
    }

    @IBAction func onContinueAction(_ sender: Any) {
        if selectedType == nil {
            fail("Please select vehicle type")
        } else {
            let params: [String: Any] = [
                "user_id": Defaults.userId.value,
                "vehicle_type": selectedType!.rawValue,
            ]
            post(url: "vehicle_info_driver", params: params) { res in
                self.success(res["message"].stringValue)

                let vc = AppStoryboard.Vehicle.viewController(VehicleOwnershipVC.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
