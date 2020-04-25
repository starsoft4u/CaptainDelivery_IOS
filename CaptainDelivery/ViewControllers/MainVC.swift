//
//  Main1VC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2019/4/13.
//  Copyright © 2019 Eliot Gravett. All rights reserved.
//

import UIKit

class MainVC: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if Defaults.isDriver.value {
            viewControllers = [
                subViewController(title: "Home", image: #imageLiteral(resourceName: "tab_home.png"), viewController: AppStoryboard.Main.viewController(DriverHomeVC.self)),
                subViewController(title: "Orders", image: #imageLiteral(resourceName: "tab_orders.png"), viewController: AppStoryboard.Main.viewController(OrderTabVC.self)),
                subViewController(title: "Notifications", image: #imageLiteral(resourceName: "tab_notification.png"), viewController: AppStoryboard.Main.viewController(NotificationVC.self)),
                subViewController(title: "Profile", image: #imageLiteral(resourceName: "tab_profile.png"), viewController: AppStoryboard.Profile.viewController(DriverProfileVC.self))
            ]
        } else {
            viewControllers = [
                subViewController(title: "Home", image: #imageLiteral(resourceName: "tab_home.png"), viewController: AppStoryboard.Main.viewController(CustomerHomeVC.self)),
                subViewController(title: "Orders", image: #imageLiteral(resourceName: "tab_orders.png"), viewController: AppStoryboard.Main.viewController(OrderTabVC.self)),
                subViewController(title: "Notifications", image: #imageLiteral(resourceName: "tab_notification.png"), viewController: AppStoryboard.Main.viewController(NotificationVC.self)),
                subViewController(title: "Profile", image: #imageLiteral(resourceName: "tab_profile.png"), viewController: AppStoryboard.Profile.viewController(CustomerProfileVC.self))
            ]
        }
    }

    private func subViewController(title: String?, image: UIImage?, viewController: UIViewController) -> UIViewController {
        let vc = UINavigationController(rootViewController: viewController)
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
        vc.navigationBar.tintColor = .black
        vc.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Constants.Font.Helvetica.regular.withSize(19)
        ]
        return vc
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Tabbar item selected background
        let itemCount = CGFloat(tabBar.items?.count ?? 1)
        let tabSize = CGSize(width: tabBar.frame.width / itemCount, height: tabBar.frame.height)

        UIGraphicsBeginImageContext(tabSize)
        #imageLiteral(resourceName: "tabbar_bg").draw(in: CGRect(x: 0, y: 0, width: tabSize.width, height: tabSize.height))
        let selBg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        tabBar.selectionIndicatorImage = selBg
    }

}
