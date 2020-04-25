//
//  VehicleOwnershipVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/31.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NKVPhonePicker
import SwiftValidators

class VehicleOwnershipVC: UITableViewController {
    @IBOutlet weak var ownerNameView: SkyFloatingLabelTextField!
    @IBOutlet weak var ownerAddressView: SkyFloatingLabelTextField!
    @IBOutlet weak var ownerCountryView: SkyFloatingLabelTextField!
    @IBOutlet weak var ownerCityView: SkyFloatingLabelTextField!
    @IBOutlet weak var companyNameView: SkyFloatingLabelTextField!
    @IBOutlet weak var emailView: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberView: NKVPhonePickerTextField!
    @IBOutlet weak var registrationNoView: SkyFloatingLabelTextField!
    @IBOutlet weak var vinNumberView: SkyFloatingLabelTextField!
    @IBOutlet weak var ignitionKeyView: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()

        setup(tableView)

        ownerNameView.text = Defaults.userName.value
        emailView.text = Defaults.userEmail.value
        if let country = Defaults.userCountry.value, let phone = Defaults.userPhoneNumber.value {
            phoneNumberView.text = "\(country)\(phone)"
        }

        phoneNumberView.phonePickerDelegate = self
    }

    @IBAction func onContinueAction(_ sender: Any) {
        if Validator.isEmpty().apply(ownerAddressView.text) {
            fail("Please input the full address", for: ownerAddressView)
        } else if Validator.isEmpty().apply(ownerCountryView.text) {
            fail("Please input the country", for: ownerCountryView)
        } else if Validator.isEmpty().apply(ownerCityView.text) {
            fail("Please input the city", for: ownerCityView)
        } else if Validator.isEmpty().apply(companyNameView.text) {
            fail("Please input the company name", for: companyNameView)
        } else if Validator.isEmpty().apply(emailView.text) {
            fail("Please input the email address", for: emailView)
        } else if Validator.isEmpty().apply(registrationNoView.text) {
            fail("Please input the registration no of the vehicle", for: registrationNoView)
        } else if Validator.isEmpty().apply(vinNumberView.text) {
            fail("Please input the vin number", for: vinNumberView)
        } else if !Validator.exactLength(14).apply(vinNumberView.text) {
            fail("Vin number should be 14 characters long", for: vinNumberView)
        } else if Validator.isEmpty().apply(ignitionKeyView.text) {
            fail("Please input the ignition key number", for: ignitionKeyView)
        } else {
            let params: [String: Any] = [
                "user_id": Defaults.userId.value,
                "full_address": ownerAddressView.text!,
                "company_name": companyNameView.text!,
                "owner_country": ownerCountryView.text!,
                "owner_city": ownerCityView.text!,
                "registeration_vehicle": registrationNoView.text!,
                "vin_number": vinNumberView.text!,
                "ignition_key_number": ignitionKeyView.text!,
            ]
            post(url: "vehicle_info_driver", params: params) { res in
                self.success(res["message"].stringValue)

                let vc = AppStoryboard.Profile.viewController(DriverLicenseVC.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
