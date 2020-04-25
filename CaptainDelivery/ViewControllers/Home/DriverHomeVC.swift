//
//  DriverHomeVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/4/13.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class DriverHomeVC: CommonVC {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressPanel: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accurateLabel: UILabel!
    @IBOutlet weak var addressText: UITextField!

    let regionRadius: CLLocationDistance = 1000
    let annotationIdentifier = "annotation"

    var selectedCoordinate: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

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
//            if let dict = placeMarks?.first?.addressDictionary {
//                let json = JSON(dict)
//                self.countryTextView.text = json["Country"].string
//                self.cityTextView.text = json["City"].string
//                self.streetTextView.text = json["Street"].string
//            } else {
//                self.countryTextView.text = nil
//                self.cityTextView.text = nil
//                self.streetTextView.text = nil
//            }
        }

        // Update location
        selectedCoordinate = location.coordinate
    }

    @IBAction func onSubmitAction(_ sender: Any) {
    }

}
