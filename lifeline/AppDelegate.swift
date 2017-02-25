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

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?


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
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
            self.window?.rootViewController = initialViewController
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
