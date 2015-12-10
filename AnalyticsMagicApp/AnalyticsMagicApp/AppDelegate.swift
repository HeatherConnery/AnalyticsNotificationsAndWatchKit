//
//  AppDelegate.swift
//  AnalyticsMagicApp
//
//  Created by Heather Connery on 2015-12-10.
//  Copyright © 2015 HConnery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Start logging with FLurry
        Flurry.startSession("JYKRSVBBZJH7SQH2G35R")
        let dictionary = ["CustomField":"CustomData"]
        Flurry.logEvent("Application was launched")
        //How long does it take to set up the Notifications?
        Flurry.logEvent("Application Was Started", withParameters: dictionary, timed: true)
        
        
        //We could trigger this anywhere in app
        subscribeToPushNotifications()
        createAndScheduleLocalNotification()
        
        Flurry.endTimedEvent("Application Was Started", withParameters: [:])
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Push Notifications
    func subscribeToPushNotifications() {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil )
        //list of notifications user agreed to accept
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print(notificationSettings)
    }
    
    //if user denies push notifications
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
        // Errors may not log right away after a crash - if they don't go back into the app you will never get this message
        Flurry.logError("Attempting to register for push notifications", message: "Error", error: error)
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Received: \(userInfo)")
        //Parsing userinfo: (aps = apple push services)
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject> {
            print(info)
            Flurry.logEvent("Notification Received", withParameters: info)
        }
        
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("Did receive local notification")
        print(notification.alertBody)
        Flurry.logEvent("Notification Received", withParameters: notification.userInfo)
    }
    
    func createAndScheduleLocalNotification() {
        // trigger immediately - can change the timing
        let notification = UILocalNotification()
        notification.alertBody = "Woot I love making alerts happen"
        //what is displayed to user when app is closed but alert comes in: (default is slide to open)
        notification.alertAction = "open"
        //when notification is pending to trigger - default NSDate() is now
        notification.fireDate = NSDate()
        //can include keys/values for passing detailed info to user
        notification.userInfo = [:]
        notification.category = "Local Notification"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
}

