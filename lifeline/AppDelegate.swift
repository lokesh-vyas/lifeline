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

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "523732833608"
    var myLocManager = CLLocationManager()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        //Current Location
        myLocManager.delegate = self
        CLLocationManager.locationServicesEnabled()
        myLocManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocManager.startUpdatingLocation()
        
        myLocManager.requestWhenInUseAuthorization()
        
        //MARK:Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        self.checkForViewControllers()
        
        GMSServices.provideAPIKey("AIzaSyANI0kErKaaeku5vY_pNlGCG7a6LUIhlq8")
        GMSPlacesClient.provideAPIKey("AIzaSyANI0kErKaaeku5vY_pNlGCG7a6LUIhlq8")
        //create the notificationCenter
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            // set the type as sound or badge
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                // Enable or disable features based on authorization
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            
            //Local Notifications
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound]
            
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
            }
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    // Notifications not allowed
                }
            }

            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        FIRApp.configure()
        return true
    }
    
    //MARK:- Location Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\((manager.location?.coordinate.latitude)!) && \((manager.location?.coordinate.longitude)!)")
        SingleTon.SharedInstance.currentLatitude = (manager.location?.coordinate.latitude)!
        SingleTon.SharedInstance.currentLongitude = (manager.location?.coordinate.longitude)!
        
        if manager.location?.coordinate.latitude != nil {
            myLocManager.stopUpdatingLocation()
        }
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let userINFO = JSON(userInfo)
        var type:String!
        var ID:String!
        var titleInDict = ""
        var messageInDict = ""
        var IDFetchString:String!
        
        if userINFO["gcm.notification.Type"].string != nil
        {   type = userINFO["gcm.notification.Type"].string!
        } else {
            type = String(describing: userINFO["gcm.notification.Type"].int)
        }
        
        if userINFO["Type"].string != nil {
            type = userINFO["Type"].string!
        }
        
        if (type == "2")
        {
            //After accecpt request
            IDFetchString = "gcm.notification.RequestID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        }else if(type == "4")
        {
            //For Camp and Thank you for after confirm camp request
            IDFetchString = "gcm.notification.CampaignID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        }else if(type == "3")
        {
            //for individual request notificaton
            IDFetchString = "gcm.notification.RequestID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
        } else if(type == "11" || type == "12") {
            
            IDFetchString = String(describing: userINFO["ID"])
            titleInDict = String(describing: userINFO["Title"])
            messageInDict = String(describing: userINFO["Body"])
            ID = IDFetchString
            
        } else {
            IDFetchString = ""
        }
        
        if userINFO[IDFetchString].string != nil
        {
            ID = userINFO[IDFetchString].string!
        } else {
            ID = String(describing: userINFO[IDFetchString].int)
        }
        if titleInDict == ""
        {
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
        }
        
        let myDict = ["Title" : "\(titleInDict)", "Message" : "\(messageInDict)", "Type" : type!,"ID" : ID]
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object:myDict)
        })
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        let userINFO = JSON(userInfo)
        var type:String!
        var ID:String!
        var titleInDict = ""
        var messageInDict = ""
        var IDFetchString:String!
        
        if userINFO["gcm.notification.Type"].string != nil
        {   type = userINFO["gcm.notification.Type"].string!
        } else {
            type = String(describing: userINFO["gcm.notification.Type"].int)
        }
        
        if userINFO["Type"].string != nil {
            type = userINFO["Type"].string!
        }
        
        if (type == "2")
        {
            //After accecpt request
            IDFetchString = "gcm.notification.RequestID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        }else if(type == "4")
        {
            //For Camp and Thank you for after confirm camp request
            IDFetchString = "gcm.notification.CampaignID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        }else if(type == "3")
        {
            //for individual request notificaton
            IDFetchString = "gcm.notification.RequestID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
        } else if(type == "11" || type == "12") {
            
            IDFetchString = String(describing: userINFO["ID"])
            titleInDict = String(describing: userINFO["Title"])
            messageInDict = String(describing: userINFO["Body"])
            ID = IDFetchString
            
        } else {
            IDFetchString = ""
        }
        
        if userINFO[IDFetchString].string != nil
        {
            ID = userINFO[IDFetchString].string!
        } else {
            ID = String(describing: userINFO[IDFetchString].int)
        }
        if titleInDict == ""
        {
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
        }
        
        let myDict = ["Title" : "\(titleInDict)", "Message" : "\(messageInDict)", "Type" : type!,"ID" : ID]
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object:myDict)
        })
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
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.prod)
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
                print("Unable to connect with FCM. \(String(describing: error))")
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
        
        if UserDefaults.standard.value(forKey: "fbID") != nil
        {
            let Loginid = UserDefaults.standard.value(forKey: "fbID")!
            let AuthProvider = UserDefaults.standard.value(forKey: "SignIN")!
            print(AuthProvider)
            UserDefaults.standard.setValue(Loginid, forKey: StringList.LifeLine_User_ID.rawValue)
            UserDefaults.standard.setValue(AuthProvider, forKey: "LoginInformation")
        }
        
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        // custom code to handle push while app is in the foreground
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        var userINFO = JSON(response.notification.request.content.userInfo)
        var type:String!
        var ID:String!
        var titleInDict = ""
        var messageInDict = ""
        var IDFetchString:String!
        
        if userINFO["gcm.notification.Type"].string != nil {
            type = userINFO["gcm.notification.Type"].string!
        } else {
            type = String(describing: userINFO["gcm.notification.Type"].int)
        }
        
        if userINFO["Type"].string != nil {
            type = userINFO["Type"].string!
        }
        
        
        if (type == "2") {
            
            //After accecpt request
            IDFetchString = "gcm.notification.RequestID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        } else if(type == "4") {
            
            //For Camp and Thank you for after confirm camp request
            IDFetchString = "gcm.notification.CampaignID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        } else if(type == "3") {
            
            //for individual request notificaton
            IDFetchString = "gcm.notification.RequestID"
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
            
        } else if(type == "11" || type == "12") {
            
            IDFetchString = String(describing: userINFO["ID"])
            titleInDict = String(describing: userINFO["Title"])
            messageInDict = String(describing: userINFO["Body"])
            ID = IDFetchString
            
        } else {
            IDFetchString = ""
        }
        
        if userINFO[IDFetchString].string != nil
        {
            ID = userINFO[IDFetchString].string!
        } else {
            ID = String(describing: userINFO[IDFetchString].int)
        }
        if titleInDict == ""
        {
            titleInDict = userINFO["aps"]["alert"]["title"].string!
            messageInDict = userINFO["aps"]["alert"]["body"].string!
        }
        
        let myDict = ["Title" : "\(titleInDict)", "Message" : "\(messageInDict)", "Type" : type!,"ID" : ID]
        
        let deadlineTime = DispatchTime.now() + .milliseconds(500)
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotification"), object:myDict)
        })
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

