//
//  Extensions.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import Foundation
import UIKit
import Networking
import SwiftyJSON
import NVActivityIndicatorView
import SideMenu
import DZNEmptyDataSet
import SwiftEntryKit

extension UIViewController {
    // Keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func goBack() {
        navigationController?.popViewController(animated: true)
    }

    // Sidemenu
    var hasMenu: Bool {
        get {
            return navigationItem.leftBarButtonItem != nil
        }
        set {
            if newValue {
                let menuBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu"), style: .plain, target: self, action: #selector(showSideMenu))
                navigationItem.leftBarButtonItem = menuBtn
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }

    func setupNavigationBar(tintColor: UIColor? = .black, backgroundColor: UIColor? = .white, transparent: Bool = false) {
        // Tint
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = tintColor
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes?[.foregroundColor] = tintColor
        }

        // Background
        navigationController?.navigationBar.barTintColor = backgroundColor

        // Transparent
        if transparent {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        } else {
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        }
    }

    @IBAction func showSideMenu() {
        SideMenuManager.default.menuWidth = CGFloat.maximum(240, view.frame.width * 0.85)
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    func backToStopRegister() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_back"),
            style: .plain,
            target: self,
            action: #selector(onBackAction))
    }

    @objc func onBackAction() {
        let view: AlertView = .loadViewFromNib()
        view.setup(title: "Confirm", message: "Do you want to cancel the registration process?")
        view.onOkay = {
            self.post(url: "delete_request", params: ["user_id": Defaults.userId.value]) { [unowned self] res in
                self.logout()
            }
        }
        dialog(view)
    }

    func logout() {
        Defaults.clear()

        if let vc = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            vc.popToRootViewController(animated: true)
        }
    }
}



// MARK - UITableView
extension UIViewController {
    func setup<T: UITableViewCell>(_ tableView: UITableView, cellClass: [T.Type] = [], pullToRefresh: Bool = false) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        cellClass.forEach {
            let nib = UINib(nibName: $0.nibName, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: $0.identifier)
        }

        if pullToRefresh {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(onPullRefresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }

    @objc func onPullRefresh() { }
}



// MARK - Alert
extension UIViewController {
    func toast(_ message: String, success: Bool = true) {
        let title = EKProperty.LabelContent(text: "", style: .init(font: UIFont.systemFont(ofSize: 20), color: success ? .black : .white))
        let description = EKProperty.LabelContent(
            text: message,
            style: .init(font: UIFont.systemFont(ofSize: 17), color: success ? .black : .white, alignment: .left)
        )

        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)

        var attributes = EKAttributes()
        attributes.windowLevel = .statusBar
        attributes.screenBackground = .clear
        attributes.entryBackground = success ? .color(color: .green) : .color(color: .red)
        attributes.roundCorners = .none
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        attributes.border = .none
        attributes.entranceAnimation = .init(translate: .init(duration: 0.2, anchorPosition: .top))
        attributes.exitAnimation = .init(translate: .init(duration: 0.2, anchorPosition: .top))
        attributes.position = .top
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.size = .screen
        attributes.displayDuration = 2
        attributes.precedence = .enqueue(priority: EKAttributes.Precedence.Priority.max)

        SwiftEntryKit.display(entry: contentView, using: attributes)
    }

    func success(_ message: String) {
        toast(message)
    }

    func fail(_ message: String, for control: UIView? = nil) {
        toast(message, success: false)
        control?.becomeFirstResponder()
    }

    func dialog(_ dialog: UIView) {
        var attributes = EKAttributes()
        attributes.displayDuration = .infinity
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.entranceAnimation = .init(scale: .init(from: 0, to: 1, duration: 0.3), fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(scale: .init(from: 1, to: 0, duration: 0.3), fade: .init(from: 1, to: 0, duration: 0.3))
        attributes.border = .value(color: .primaryColor, width: 2)
        attributes.roundCorners = .all(radius: 16)
        attributes.scroll = .disabled
        attributes.position = .center
        attributes.positionConstraints.maxSize = .init(width: .offset(value: 24), height: .intrinsic)
        attributes.screenBackground = .color(color: UIColor.black.withAlphaComponent(0.5))
        attributes.precedence = .enqueue(priority: EKAttributes.Precedence.Priority.high)

        SwiftEntryKit.display(entry: dialog, using: attributes)
    }

}



// MARK - Activity indicator
extension UIViewController: NVActivityIndicatorViewable { }


// MARK - Networking
extension UIViewController {
    func handleResponse(url: String, result: JSONResult, completion: ((_ res: JSON) -> Void)?) {
        switch result {
        case .success(let res):
            print("[$] Response [\(url)] success : \(res.dictionaryBody)")
            let json = JSON(res.dictionaryBody)
            if json["status"].boolValue {
                completion?(json)
            } else {
                let errorMessage = json["message"].string ?? "Something went wrong, try again"
                print("[$] Response [\(url)] Failed : \(errorMessage)")
                fail(errorMessage)
            }

        case .failure(let res):
            print("[$] response [\(url)] Failed : \(res.error)")
            fail(res.error.localizedDescription)
        }
    }

    func get(
        url: String,
        params: [String: Any]? = nil,
        indicator: Bool = true,
        refreshControl: UIRefreshControl? = nil,
        completion: ((_ res: JSON) -> Void)? = nil) {

        if indicator, !isAnimating {
            startAnimating()
        }

        print("[$] GET: \(url) Parameter: \(params?.debugDescription ?? "[]")")

        let net: Networking = Networking(baseURL: Constants.Url.api)
//        if let token = Defaults.apiToken.value {
//            net.setAuthorizationHeader(token: token)
//        }
        net.get(url, parameters: params) { result in
            if indicator, self.isAnimating {
                self.stopAnimating()
            }
            refreshControl?.endRefreshing()
            self.handleResponse(url: url, result: result, completion: completion)
        }
    }

    func post(
        url: String,
        params: [String: Any]? = nil,
        paramType: Networking.ParameterType = .json,
        parts: [FormDataPart] = [],
        indicator: Bool = true,
        refreshControl: UIRefreshControl? = nil,
        completion: ((_ res: JSON) -> Void)? = nil) {

        if indicator, !isAnimating {
            startAnimating()
        }

        print("[$] POST: \(url) Parameter: \(params?.debugDescription ?? "[]")")

        let net: Networking = Networking(baseURL: Constants.Url.api)
//        if let token = Defaults.apiToken.value {
//            net.setAuthorizationHeader(token: token)
//        }
        if parts.isEmpty {
            net.post(url, parameterType: paramType, parameters: params) { result in
                if indicator, self.isAnimating {
                    self.stopAnimating()
                }
                refreshControl?.endRefreshing()
                self.handleResponse(url: url, result: result, completion: completion)
            }
        } else {
            net.post(url, parameters: params, parts: parts) { result in
                if indicator, self.isAnimating {
                    self.stopAnimating()
                }
                refreshControl?.endRefreshing()
                self.handleResponse(url: url, result: result, completion: completion)
            }
        }

    }
}
