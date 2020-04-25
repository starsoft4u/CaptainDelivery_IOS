//
//  Helper.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit

final class Defaults {
    enum LoginMethod: String {
        case normal, google, facebook
    }

    class func clear(except keys: [Any] = []) {
        if !keys.contains(where: { $0 is userId }) { userId.value = userId.defaultValue }
        if !keys.contains(where: { $0 is userName }) { userName.value = userName.defaultValue }
        if !keys.contains(where: { $0 is userEmail }) { userEmail.value = userEmail.defaultValue }
        if !keys.contains(where: { $0 is loginMethod }) { loginMethod.value = loginMethod.defaultValue }
        if !keys.contains(where: { $0 is userCountryCode }) { userCountryCode.value = userCountryCode.defaultValue }
        if !keys.contains(where: { $0 is userPhoneNumber }) { userPhoneNumber.value = userPhoneNumber.defaultValue }
        if !keys.contains(where: { $0 is userPhotoUrl }) { userPhotoUrl.value = userPhotoUrl.defaultValue }
        if !keys.contains(where: { $0 is userLat }) { userLat.value = userLat.defaultValue }
        if !keys.contains(where: { $0 is userLng }) { userLng.value = userLng.defaultValue }
        if !keys.contains(where: { $0 is userCountry }) { userCountry.value = userCountry.defaultValue }
        if !keys.contains(where: { $0 is userCity }) { userCity.value = userCity.defaultValue }
        if !keys.contains(where: { $0 is userStreet }) { userStreet.value = userStreet.defaultValue }
        if !keys.contains(where: { $0 is userRate }) { userRate.value = userRate.defaultValue }
        if !keys.contains(where: { $0 is isDriver }) { isDriver.value = isDriver.defaultValue }
    }

    struct deviceToken: TSUD {
        static let defaultValue: String = ""
    }
    struct userId: TSUD {
        static let defaultValue: Int = 0
    }
    struct userName: TSUD {
        static let defaultValue: String? = nil
    }
    struct userEmail: TSUD {
        static let defaultValue: String? = nil
    }
    struct userCountryCode: TSUD {
        static let defaultValue: String? = nil
    }
    struct userPhoneNumber: TSUD {
        static let defaultValue: String? = nil
    }
    struct userPhotoUrl: TSUD {
        static let defaultValue: String? = nil
    }
    struct userLat: TSUD {
        static let defaultValue: Double = 0
    }
    struct userLng: TSUD {
        static let defaultValue: Double = 0
    }
    struct userCountry: TSUD {
        static let defaultValue: String? = nil
    }
    struct userCity: TSUD {
        static let defaultValue: String? = nil
    }
    struct userStreet: TSUD {
        static let defaultValue: String? = nil
    }
    struct userRate: TSUD {
        static let defaultValue: Double = 0
    }
    struct isDriver: TSUD {
        static let defaultValue: Bool = true
    }
    struct loginMethod: TSUD {
        static let defaultValue: String = LoginMethod.normal.rawValue
    }
    struct driverId: TSUD {
        static let defaultValue: Int = 0
    }
    struct customerId: TSUD {
        static let defaultValue: Int = 0
    }
}

enum AppStoryboard: String {
    case Main, Vehicle, Order, Profile

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(_ viewControllerClass: T.Type) -> T {
        let storyboardIdentifier = (viewControllerClass as UIViewController.Type)
        return instance.instantiateViewController(withIdentifier: "\(storyboardIdentifier)") as! T
    }
}

final class Constants {
    struct Url {
        static let base = "http://delivery.kavaltek.com"
        static let api = "\(base)/App/"
        static let twilioBase = "https://api.authy.com"
        static let twilioKey = "cpfasOFQW9KRjX7UxQnoABesj11QDeZK"
    }

    struct Font {
        struct Helvetica {
            public static let regular = UIFont(name: "Helvetica", size: 14)!
        }
        struct Roboto {
            public static let regular = UIFont(name: "Roboto-Regular", size: 14)!
        }
    }
}
