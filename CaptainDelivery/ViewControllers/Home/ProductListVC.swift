//
//  ProductListVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import SwiftyJSON
import XLPagerTabStrip
import SwiftyAttributes

enum HomePage: String {
    case all = "All"
    case history = "History"
    case nearby = "See Nearby"
}

class ProductListVC: UITableViewController {
    let sectionHeight: CGFloat = 48
    var page: HomePage!
    var products: [[Product]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setup(tableView, cellClass: [ProductCell.self], pullToRefresh: false)

        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        loadData()
    }

    fileprivate func loadData() {
        // Temp
        let json = JSON(parseJSON: """
                [{"icon":"", "name":"Name 1", "desc": "Description 1"},
                {"icon":"", "name":"Name 2", "desc": "Description 2"},
                {"icon":"", "name":"Name 3", "desc": "Description 3"},
                {"icon":"", "name":"Name 4", "desc": "Description 4"}]
            """)

        if page == .all {
            products = [
                json.arrayValue.map(Product.init(json:)),
                json.arrayValue.map(Product.init(json:)),
            ]
        } else {
            products = [
                json.arrayValue.map(Product.init(json:)),
            ]
        }
    }

    @objc fileprivate func onSeeAllNearByAction() {
        guard let homeVC = parent as? CustomerHomeVC else { return }
        homeVC.moveToViewController(at: 2)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { fatalError() }

        let product = self.products[indexPath.section][indexPath.row]

        cell.iconView.image = #imageLiteral(resourceName: "ic_package")
        cell.nameView.text = product.name
        cell.descView.text = product.desc

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard page == .all else { return nil }

        return section == 0 ? "See Nearby" : "Most Active"
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return page == .all ? sectionHeight : 0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard page == .all else { return nil }

        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: sectionHeight))
        header.backgroundColor = .lightGrey

        let label = UILabel(frame: CGRect(x: 12, y: 0, width: tableView.frame.width - 24, height: sectionHeight))
        label.text = section == 0 ? " See Nearby" : "Most Active"
        label.font = Constants.Font.Helvetica.regular.withSize(19)
        label.textColor = .normalTextColor
        header.addSubview(label)

        if section == 0 {
            let button = UIButton(type: .system)
            button.setTitle("See all >", for: .normal)
            button.titleLabel?.font = Constants.Font.Helvetica.regular.withSize(17)
            button.tintColor = .orange
            button.sizeToFit()
            button.frame = CGRect(x: header.frame.width - 24 - button.frame.width, y: 0, width: button.frame.width, height: sectionHeight)
            button.addTarget(self, action: #selector(onSeeAllNearByAction), for: .touchUpInside)
            header.addSubview(button)
        }

        return header
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = AppStoryboard.Order.viewController(OrderVC.self)
        vc.product = products[indexPath.section][indexPath.row]
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

extension ProductListVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: page.rawValue)
    }
}
