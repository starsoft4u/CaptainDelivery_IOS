//
//  OrderVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/11.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit

class OrderVC: UITableViewController {
    @IBOutlet weak var requestTextView: UITextView!

    var product: Product!

    override func viewDidLoad() {
        super.viewDidLoad()

        setup(tableView, cellClass: [ProductCell.self], pullToRefresh: false)
    }

    @IBAction func onDoneAction(_ sender: Any) {
        success("Order done!")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row == 0 else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { fatalError() }

        cell.selectionStyle = .none
        cell.iconView.image = #imageLiteral(resourceName: "ic_package")
        cell.nameView.text = product.name
        cell.descView.text = product.desc

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 1 {
            // Delivery location
        } else if indexPath.row == 2 {
            // Delivery time
        }
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
