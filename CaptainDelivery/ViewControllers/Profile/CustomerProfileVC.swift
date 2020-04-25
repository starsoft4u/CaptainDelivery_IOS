//
//  CustomerProfileVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/12.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import NKVPhonePicker
import SkyFloatingLabelTextField

class CustomerProfileVC: UITableViewController {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var firstNameView: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameView: SkyFloatingLabelTextField!
    @IBOutlet weak var emailView: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberView: NKVPhonePickerTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
