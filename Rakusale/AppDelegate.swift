//
//  AppDelegate.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/07/05.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
        center.delegate = self
//        // 通知の内容を設定する
//        let content = UNMutableNotificationContent()
//        content.title = "Local"
//        content.body = "aaa"
//        content.userInfo = ["id": 1]
//
//        // 通知の条件を設定する
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//        // 通知のリクエストを生成する
//        let request = UNNotificationRequest(identifier: "Rakusale", content: content, trigger: trigger)
//        // 通知をシステムに登録する
//        UNUserNotificationCenter.current().add(request)
        //let _ = LocalNotificationService.sharedManager.sendLocalNotification(title: "らくセール", subtitle: "本日の売り上げ", body: "お疲れ様です。本日の売り上げは、13000円です。")
        return true
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

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
}

