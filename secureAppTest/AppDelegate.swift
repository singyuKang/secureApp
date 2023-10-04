//
//  AppDelegate.swift
//  secureAppTest
//
//  Created by 강신규 on 2023/08/24.
//

import UIKit
import NMapsMap
import FirebaseCore
import KakaoSDKCommon
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //launchScreen에서 작업할 내용
        
        UNUserNotificationCenter.current().delegate = self
        NMFAuthManager.shared().clientId = "vbbb1u6hk5"
        
        KakaoSDK.initSDK(appKey: "27eee38f87e06c631291470021c6af19")
        
        FirebaseApp.configure()
        
        //KeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        // TODO. 스플래시 딜레이 1초
        Thread.sleep(forTimeInterval: 1.0)
        
        return true
        
        
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
        
        
    }
    
    func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
      print("AppDelegate didReceiveRemoteNotification userInfo :::::::::::", userInfo)
    }
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // deep link처리 시 아래 url값 가지고 처리
        let userInfo = response.notification.request.content.userInfo
        print("AppDelegate userInfo didReceive ::::::::::::", userInfo[0])
        completionHandler()
    }
}

