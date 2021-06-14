//
//  AppDelegate.swift
//  ablytest
//
//  Created by Taeheon Woo on 2021/06/12.
//

import UIKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = TabBarViewController()
    window?.makeKeyAndVisible()
    return true
  }
}

