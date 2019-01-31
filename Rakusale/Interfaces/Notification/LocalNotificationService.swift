//
//  LocalNotificationService.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/12/03.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import NotificationCenter

class LocalNotificationService: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    // シングルトン
    static let sharedManager = LocalNotificationService()
    // Push通知の許可を取る
    func checkPushAuthorization() {
        self.center.requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
            if !granted {
                debugPrint("Pushの許諾が拒否されました")
                return
            }
            else {
                debugPrint("Pushの許諾が許可されました")
            }
        }
    }
    
    // ローカルPush通知の関数
    func sendLocalNotification(title: String, subtitle: String, body: String) {
        self.content.title = title
        self.content.subtitle = subtitle
        self.content.body = body
        self.content.badge = 1
        self.content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "RakusalePush", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
