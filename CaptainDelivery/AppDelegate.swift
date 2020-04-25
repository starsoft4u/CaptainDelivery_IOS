//
//  AppDelegate.swift
//  CaptainDelivery
//
//  Created by Eliot Gravett on 2018/12/10.
//  Copyright © 2018 Eliot Gravett. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenu
import YPImagePicker
import UserNotifications
import GoogleSignIn
import FacebookCore
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Keyboard
        IQKeyboardManager.shared.enable = true

        // SideMenu
        SideMenuManager.default.menuLeftNavigationController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "MenuNavVC") as? UISideMenuNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        SideMenuManager.default.menuShadowOpacity = 0.5

        // Image picker
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.onlySquareImagesFromCamera = false
        config.albumName = "Captain Delivery"
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.hidesStatusBar = false
        config.showsCrop = .none
        YPImagePickerConfiguration.shared = config

        // Location
        LocationManager.shared.requestLocationUpdate()

        // FIrebase
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self

        // Google
        GIDSignIn.sharedInstance().clientID = "382685849185-0egagf35jifm23udal9bku53n239ahl3.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        // Facebook
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        // Notification
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
//        } else {
//            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        application.registerForRemoteNotifications()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let google = GIDSignIn.sharedInstance().handle(
            url as URL?,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

        let facebook = SDKApplicationDelegate.shared.application(app, open: url, options: options)

        return google || facebook
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("[$] Did register for notification with token >>> \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("[$] Failed to register for notification with error : \(error.localizedDescription)")
    }
}


@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("[$] Notification did receive response >>> \(userInfo)")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("[$] Notification will present with >>> \(userInfo)")
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler([.sound, .alert, .badge])
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("[$] Did receive FCMToken >>> \(fcmToken)")
        
        Defaults.deviceToken.value = fcmToken
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        let userInfo = remoteMessage.appData
        print("[$] Did receive remote message >>> \(userInfo)")
    }
}
