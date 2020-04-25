//
//  VehicleDetailVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/30.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftValidators
import YPImagePicker
import DropDown
import Networking

class VehicleDetailVC: UITableViewController {
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var brandTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var modelTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var yearTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var colorTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var interiorColorTextView: SkyFloatingLabelTextField!

    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()

        setup(tableView)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @IBAction func onImageTappedAction(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.startOnScreen = .library

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.vehicleImageView.contentMode = .scaleAspectFill
                self.vehicleImageView.image = photo.image
                self.selectedImage = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    @IBAction func onYearTappedAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        let thisYear = Calendar.current.component(.year, from: Date())
        dropDown.dataSource = (1900...thisYear).map { $0.description }
        dropDown.selectionAction = { [unowned self] index, item in
            self.yearTextView.text = item
        }
        dropDown.show()
    }

    @IBAction func onContinueAction(_ sender: Any) {
        if selectedImage == nil {
            fail("Please select the photo")
        } else if Validator.isEmpty().apply(brandTextView.text) {
            fail("Please input the brand", for: brandTextView)
        } else if Validator.isEmpty().apply(modelTextView.text) {
            fail("Please input the model", for: modelTextView)
        } else if Validator.isEmpty().apply(yearTextView.text) {
            fail("Please input the year", for: yearTextView)
        } else if Validator.isEmpty().apply(modelTextView.text) {
            fail("Please input the model", for: modelTextView)
        } else if Validator.isEmpty().apply(colorTextView.text) {
            fail("Please input the color", for: colorTextView)
        } else if Validator.isEmpty().apply(interiorColorTextView.text) {
            fail("Please input the interior color", for: interiorColorTextView)
        } else {
            let params: [String: Any] = [
                "user_id": Defaults.userId.value,
                "brand": brandTextView.text!,
                "model": modelTextView.text!,
                "year": yearTextView.text!,
                "color": colorTextView.text!,
                "interior_color": interiorColorTextView.text!,
            ]
            let part = FormDataPart(type: .jpg, data: selectedImage!.jpegData(compressionQuality: 0.5)!, parameterName: "vehicle_image", filename: "vehicle.jpg")
            post(url: "vehicle_info_driver", params: params, parts: [part]) { res in
                self.success(res["message"].stringValue)

                let vc = AppStoryboard.Vehicle.viewController(VehicleTypeVC.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
