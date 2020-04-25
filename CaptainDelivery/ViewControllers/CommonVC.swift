//
//  CommonVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/10.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit

class CommonVC: UIViewController {

    func viewWillAppear(_ animated: Bool, _ hiddenNavBar: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hiddenNavBar, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
