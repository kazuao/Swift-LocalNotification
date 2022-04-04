//
//  AppDelegate.swift
//  LocalNotification
//
//  Created by kazunori.aoki on 2022/03/31.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if error != nil {
                    print("Error: ", error!.localizedDescription)
                    return
                }

                if granted {
                    print("authorized")
                    UNUserNotificationCenter.current().delegate = self
                } else {
                    print("denied")
                }
            }

        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .list, .sound]])
        } else {
            completionHandler([[.alert, .sound]])
        }
    }
}
