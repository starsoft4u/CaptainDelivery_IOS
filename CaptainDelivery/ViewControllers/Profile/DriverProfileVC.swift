//
//  DriverProfileVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/12.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit

class DriverProfileVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setup(tableView)
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
