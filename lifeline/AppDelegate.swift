//
//  AppDelegate.swift
//  lifeline
//
//  Created by iSteer on 06/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Google
import GoogleSignIn
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import SwiftyJSON


//Notification
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?
    let gcmMessageIDKey = "523732833608"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        //MARK:Facebook
         FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        

       
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        self.checkForViewControllers()
        
        GMSServices.provideAPIKey("AIzaSyANI0kErKaaeku5vY_pNlGCG7a6LUIhlq8")
        GMSPlacesClient.provideAPIKey("AIzaSyANI0kErKaaeku5vY_pNlGCG7a6LUIhlq8")
        
        if #available(iOS 10.0, *)
        {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        // Add observer for InstanceID token refresh callback.
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.tokenRefreshNotification),
//                                               name: .firInstanceIDTokenRefresh,
//                                               object: nil)
        
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        let userINFO = JSON(userInfo)
        
        let type:String
        if userINFO["gcm.notification.Type"].string != nil
        {
            type = userINFO["gcm.notification.Type"].string!
        }
        else
        {
            type = String(describing: userINFO["gcm.notification.Type"].int)
        }
        
        let myDict = ["Title": userINFO["aps"]["alert"]["title"].string, "Message":userINFO["aps"]["alert"]["body"].string,"Type":type,"ID":""]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object:myDict)
        
       
        completionHandler(UIBackgroundFetchResult.newData)
    }
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
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
          FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return true
    }
    //MARK:- Check For View Controllers
    func checkForViewControllers()
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (UserDefaults.standard.value(forKey: StringList.LifeLine_User_ID.rawValue) != nil)
        {
            let profileSuccess = UserDefaults.standard.bool(forKey: "SuccessProfileRegistration")
            if profileSuccess == false
            {
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") 
                let navigationController = UINavigationController.init(rootViewController: initialViewController)
                
                self.window?.rootViewController = navigationController
            }
            else
            {
               let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
               self.window?.rootViewController = initialViewController
            }
        }
        else
        {
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginView")
            let navigationController = UINavigationController.init(rootViewController: initialViewController)
            
            self.window?.rootViewController = navigationController
        }
        self.window?.makeKeyAndVisible()
    }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let userInfo = notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey]
//        {
//            print("Message ID: \(messageID)")
//        }
//        // Change this to your preferred presentation option
//        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
  
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

