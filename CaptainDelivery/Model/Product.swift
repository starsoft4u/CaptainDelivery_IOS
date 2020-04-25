//
//  Product.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Product {
    var icon: String
    var name: String
    var desc: String

    init(json: JSON) {
        icon = json["icon"].stringValue
        name = json["name"].stringValue
        desc = json["desc"].stringValue
    }
}
