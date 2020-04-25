//
//  DriverLicenseVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/31.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import SwiftValidators
import SkyFloatingLabelTextField
import YPImagePicker
import Networking

class DriverLicenseVC: CommonVC {
    @IBOutlet weak var licenseImageView: UIImageView!
    @IBOutlet weak var licenseNumberView: SkyFloatingLabelTextField!
    @IBOutlet weak var issuedDateView: SkyFloatingLabelTextField!
    @IBOutlet weak var expiryDateView: SkyFloatingLabelTextField!

    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()
    }

    fileprivate func date2String(_ date: Date, format: String = "dd/MM/yyyy") -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: date)
    }

    @IBAction func onIssuedDateAction(_ sender: Any) {
        let view: DatePickerView = DatePickerView.loadViewFromNib()
        view.datePicked = { self.issuedDateView.text = self.date2String($0, format: "yyyy-MM-dd") }
        self.dialog(view)
    }

    @IBAction func onExpiryDateAction(_ sender: Any) {
        let view: DatePickerView = DatePickerView.loadViewFromNib()
        view.datePicked = { self.expiryDateView.text = self.date2String($0, format: "yyyy-MM-dd") }
        self.dialog(view)
    }

    @IBAction func onTapPhotoAction(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.startOnScreen = .library

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.licenseImageView.contentMode = .scaleAspectFit
                self.licenseImageView.image = photo.image
                self.selectedImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    @IBAction func onContinueAction(_ sender: Any) {
        if selectedImage == nil {
            fail("Please select the license photo")
        } else if Validator.isEmpty().apply(licenseNumberView.text) {
            fail("Please input the license number", for: licenseNumberView)
        } else if Validator.isEmpty().apply(issuedDateView.text) {
            fail("Please input the issued date", for: issuedDateView)
        } else if Validator.isEmpty().apply(expiryDateView.text) {
            fail("Please input the expiry date", for: expiryDateView)
        } else {
            let params: [String: Any] = [
                "user_id": Defaults.userId.value,
                "licence_number": licenseNumberView.text!,
                "issued_on": issuedDateView.text!,
                "expiry_date": expiryDateView.text!,
            ]
            let imageData = selectedImage!.jpegData(compressionQuality: 0.5)!
            let part = FormDataPart(type: .jpg, data: imageData, parameterName: "licence_image", filename: "vehicle.jpg")
            post(url: "vehicle_info_driver", params: params, parts: [part]) { res in
                self.fail("Your account must be activated.")

                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

}
