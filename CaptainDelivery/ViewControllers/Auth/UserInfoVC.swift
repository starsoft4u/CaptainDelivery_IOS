//
//  UserInfoVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/28.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import MapKit
import SkyFloatingLabelTextField
import YPImagePicker
import SwiftValidators
import SwiftyJSON
import Networking

class UserInfoVC: UITableViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var countryTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextView: SkyFloatingLabelTextField!
    @IBOutlet weak var streetTextView: SkyFloatingLabelTextField!

    let regionRadius: CLLocationDistance = 1000
    let annotationIdentifier = "annotation"

    var selectedCoordinate: CLLocationCoordinate2D?
    var selectedPhoto: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        backToStopRegister()

        if let location = LocationManager.shared.currentLocation {
            centerOnMapView(location: location)
        }
    }

    fileprivate func centerOnMapView(location: CLLocation) {
        // Center
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)

        // Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)

        // Address
        CLGeocoder().reverseGeocodeLocation(location) { placeMarks, error in
            if let dict = placeMarks?.first?.addressDictionary {
                let json = JSON(dict)
                self.countryTextView.text = json["Country"].string
                self.cityTextView.text = json["City"].string
                self.streetTextView.text = json["Street"].string
            } else {
                self.countryTextView.text = nil
                self.cityTextView.text = nil
                self.streetTextView.text = nil
            }
        }

        // Update location
        selectedCoordinate = location.coordinate
    }


    @IBAction func tapOnMapViewAction(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        centerOnMapView(location: location)
    }

    @IBAction func tapOnPhotoAction(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.startOnScreen = .library

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.photoImageView.contentMode = .scaleAspectFill
                self.photoImageView.image = photo.image
                self.selectedPhoto = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    @IBAction func onContinueAction(_ sender: Any) {
        if selectedPhoto == nil {
            fail("Please select photo")
        } else if selectedCoordinate == nil {
            fail("Please select location")
        } else if Validator.isEmpty().apply(countryTextView.text) {
            fail("Please input the country", for: countryTextView)
        } else if Validator.isEmpty().apply(cityTextView.text) {
            fail("Please input the city", for: cityTextView)
        } else if Validator.isEmpty().apply(streetTextView.text) {
            fail("Please input the street", for: streetTextView)
        } else {
            let params: [String: Any] = [
                "user_id": Defaults.userId.value,
                "lat": selectedCoordinate!.latitude,
                "lng": selectedCoordinate!.longitude,
                "country": countryTextView.text!,
                "city": cityTextView.text!,
                "region_street": streetTextView.text!,
            ]
            let filename = Defaults.isDriver.value ? "driver.jpg" : "customer.jpg"
            let part = FormDataPart(type: .jpg, data: selectedPhoto!.jpegData(compressionQuality: 0.5)!, parameterName: "image", filename: filename)
            let url = Defaults.isDriver.value ? "personal_info_driver" : "personal_info_customer"
            post(url: url, params: params, parts: [part]) { res in
                Defaults.userLat.value = self.selectedCoordinate!.latitude
                Defaults.userLng.value = self.selectedCoordinate!.longitude
                Defaults.userCountry.value = self.countryTextView.text
                Defaults.userCity.value = self.cityTextView.text
                Defaults.userStreet.value = self.streetTextView.text
                Defaults.userPhotoUrl.value = res["image"].string

                if Defaults.isDriver.value {
                    Defaults.driverId.value = res["ext_id"].intValue

                    let vc = AppStoryboard.Vehicle.viewController(VehicleDetailVC.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    Defaults.customerId.value = res["ext_id"].intValue
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UserInfoVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }

        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) ??
        MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)

        annotationView.image = #imageLiteral(resourceName: "ic_location_start.png")
        return annotationView
    }
}
