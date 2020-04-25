//
//  Order.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Order {
    var id: String
    var userName: String
    var amount: Double
    var method: String
    var date: String
    var hasAccepted: Bool

    init(json: JSON) {
        id = json["id"].stringValue
        userName = json["userName"].stringValue
        amount = json["amount"].doubleValue
        method = json["method"].stringValue
        date = json["date"].stringValue
        hasAccepted = json["hasAccepted"].boolValue
    }
}
