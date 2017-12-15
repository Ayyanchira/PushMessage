//
//  AppDelegate.swift
//  PushMessage
//
//  Created by Ayyanchira, Akshay Murari on 11/16/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: "deviceToken")
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        submitNewDeviceToken(token: token)
        
    }
    
    func submitNewDeviceToken(token:String) {
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "9a1acc2b-8b92-9244-4e64-c4e8525e8870"
        ]
        let parameters = [
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXRpZW50aWQiOjcsIm5hbWUiOiJwYXRpZW50MSIsImVtYWlsIjoicGF0aWVudDFAZ21haWwuY29tIiwiYWdlIjoiMjIiLCJnZW5kZXIiOiJNYWxlIiwiaWF0IjoxNTEzMjg3MTQ5fQ.8cHXlx2ymas8k8GhgB5zItDBIE8PzuhCLYi5kbIfguw",
            "device": token
            ] as [String : Any]
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://18.217.3.86:5000/updatedevicetokenapi")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = postData as Data
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    let surveyResponse = try JSONDecoder().decode(MessageSubmitResponse.self, from: data!)
                    if surveyResponse.code == 200{
                       print("Device token updated")
                    }else{
                        print("Failed to update device token")
                    }
                    //add the responded id to array
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        let vc =
      
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"MyNotification"),
                object: nil,
                userInfo: ["message":"Hello there!", "date":Date()])
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

