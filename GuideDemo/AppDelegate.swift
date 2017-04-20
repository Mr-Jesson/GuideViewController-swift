//
//  AppDelegate.swift
//  GuideDemo
//
//  Created by Jesson on 2017/4/19.
//  Copyright © 2017年 Jesson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let videoPath = Bundle.main.path(forResource: "qidong", ofType: "mp4")
        let nav = UINavigationController.init(rootViewController: ViewController())
        let guideVc = JSGuideController.init(guide: .picture, pictures: ["guide_1","guide_2","guide_3"], videoPath: nil,pushViewController:nav)
//        let guideVc = JSGuideController.init(guide: .video, pictures: nil, videoPath: videoPath,pushViewController:nav)
        self.window?.rootViewController = guideVc
       
        // 得到当前应用的版本号
//        let infoDictionary = Bundle.main.infoDictionary
//        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
//        // 取出之前保存的版本号
//        let userDefaults = UserDefaults.standard
//        let appVersion = userDefaults.string(forKey: "appVersion")
//        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
//        if appVersion == nil || appVersion != currentAppVersion {
//            // 保存最新的版本号
//            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
//            let videoPath = Bundle.main.path(forResource: "qidong", ofType: "mp4")
//            let guideVc = JSGuideController.init(guide: .video, pictures: nil, videoPath: videoPath)
//            
////            let guideVc = JSGuideController.guidedefault
//            self.window?.rootViewController = guideVc
//        }
        // Override point for customization after application launch.
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


}

