//
//  OrderListVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip

class OrderListVC: UITableViewController {
    var isActive: Bool = true
    var orders: [Order] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup(tableView, cellClass: [OrderCell.self], pullToRefresh: false)

        tableView.separatorStyle = .none

        loadData()
    }

    fileprivate func loadData() {
        // Temp
        if isActive {
            let json = JSON(parseJSON: """
                [{"id": "#012", "userName": "Aricson Smith", "amount": "112.43", "method": "Credit Card", "date": "11:45 am 01 Nov 2018", "hasAccepted": true},
                {"id": "#014", "userName": "Aricson Smith", "amount": "41", "method": "Credit Card", "date": "11:45 am 01 Nov 2018", "hasAccepted": false}]
            """)
            orders = json.arrayValue.map(Order.init(json:))
        } else {
            let json = JSON(parseJSON: """
                [{"id": "#013", "userName": "Aricson Smith", "amount": "12.43", "method": "Cash", "date": "11:45 am 01 Nov 2018", "hasAccepted": false},
                {"id": "#015", "userName": "Aricson Smith", "amount": "1.3", "method": "Cash", "date": "11:45 am 01 Nov 2018", "hasAccepted": true}]
            """)
            orders = json.arrayValue.map(Order.init(json:))
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell else { fatalError() }

        let order = orders[indexPath.row]
        cell.userNameLabel.text = order.userName
        cell.amountLabel.text = "$\(order.amount.toString())"
        cell.methodLabel.text = "Payment by \(order.method)"
        cell.identifierLabel.text = "Order \(order.id)"
        cell.dateLabel.text = "Ordered on \(order.date)"
        if order.hasAccepted {
            cell.button.setTitle("Accepted  >", for: .normal)
            cell.button.tintColor = UIColor(rgb: 0x089340)
            cell.onButtonTapped = {
                self.toast("Accepted clicked!")
            }
        } else {
            cell.button.setTitle("View order  >", for: .normal)
            cell.button.tintColor = .orange
            cell.onButtonTapped = {
                self.toast("View Order clicked!")
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = AppStoryboard.Profile.viewController(RateVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderListVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: isActive ? "Active Orders" : "Inactive Orders")
    }
}
