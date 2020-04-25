//
//  PartnerProfileVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/12.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import Cosmos

class PartnerProfileVC: CommonVC {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var cancelView: UIView!

    var partnerIsDriver: Bool = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupNavigationBar(tintColor: .white, backgroundColor: .orange)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        setupNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = partnerIsDriver ? "Driver Profile" : "Customer Profile"

        ratingBar.isHidden = !partnerIsDriver
        distanceLabel.superview?.isHidden = !partnerIsDriver
        pickView.isHidden = partnerIsDriver
        cashView.isHidden = partnerIsDriver
        payView.isHidden = !partnerIsDriver
        cancelView.isHidden = !partnerIsDriver
    }

    @IBAction func onRateAction(_ sender: Any) {
    }

    @IBAction func onChatAction(_ sender: Any) {
    }

    @IBAction func onCallAction(_ sender: Any) {
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
