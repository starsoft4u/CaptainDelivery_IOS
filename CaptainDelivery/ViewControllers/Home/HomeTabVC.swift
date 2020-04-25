//
//  HomeTabVC.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/10.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeTabVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor(rgb: 0xc2c4c5)
        settings.style.buttonBarMinimumInteritemSpacing = 1
        settings.style.buttonBarMinimumLineSpacing = 1

        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = Constants.Font.Helvetica.regular.withSize(13)
        settings.style.buttonBarItemTitleColor = UIColor(rgb: 0x9a9a9a)
        settings.style.buttonBarItemLeftRightMargin = 0

        settings.style.selectedBarBackgroundColor = .orange
        settings.style.selectedBarHeight = 2

        changeCurrentIndexProgressive = { (old, new, percent, changeCurrentIndex, animate) -> Void in
            guard changeCurrentIndex else { return }

            old?.contentView.backgroundColor = .white
            old?.backgroundColor = .clear
            old?.label.textColor = UIColor(rgb: 0x9a9a9a)

            new?.contentView.backgroundColor = .lightGrey
            new?.backgroundColor = .clear
            new?.label.textColor = .normalTextColor
        }

        super.viewDidLoad()

        let bottomBar = UIView(frame: CGRect(x: 0, y: buttonBarView.frame.height - 2, width: buttonBarView.frame.width, height: 2))
        bottomBar.backgroundColor = UIColor(rgb: 0xc2c4c5)
        buttonBarView.addSubview(bottomBar)
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let all = ProductListVC()
        all.page = .all

        let history = ProductListVC()
        history.page = .history

        let nearby = ProductListVC()
        nearby.page = .nearby

        return [all, history, nearby]
    }
}
