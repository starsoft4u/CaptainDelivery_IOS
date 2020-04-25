//
//  LocationManager.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/3/28.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import Foundation
import MapKit

@objc protocol LocationManagerDelegate {
    @objc optional func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}

class LocationManager: NSObject {
    static let shared = LocationManager()

    let locationManager = CLLocationManager()

    var delegate: LocationManagerDelegate?

    var currentLocation: CLLocation? {
        return locationManager.location
    }

    private override init() {
        super.init()

        locationManager.delegate = self
    }

    func requestLocationUpdate() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager?(manager, didUpdateLocations: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed to update location: \(error)")
    }
}
