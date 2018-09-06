//
//  AppDelegate.swift
//  RemoteConfigRxWrapper
//
//  Created by Markus Mattfolk Stenberg on 09/06/2018.
//  Copyright (c) 2018 Markus Mattfolk Stenberg. All rights reserved.
//

import UIKit
import RemoteConfigRxWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let newValues = ["welcomeTitle": "New config fetched",
                   "systemStatusStartDate": "2018-09-06T13:54:10+00:00",
                   "systemStatusEndDate": "2019-09-06T13:54:10+00:00",
                   "systemStatusTitle": "Alert title",
                   "systemStatusText": "Alert text"]
  let defaultValues = ["welcomeTitle": "Press the button to fetch new remote config!" ]
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let remoteConfigMock = RemoteConfigMock(defaultValues: defaultValues as [String : NSObject])
    remoteConfigMock.newValues = newValues as [String : NSObject]
    RemoteConfigRxWrapper.sharedInstance.setupRemoteConfig(remoteConfig: remoteConfigMock)
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

