//
//  HomeView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import UserNotifications

class HomeView: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var revalMenuButton: UIBarButtonItem!
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
       //MARK - Reval View Button
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let deviceRegister = UserDefaults.standard.bool(forKey: "DeviceRegister")
        if deviceRegister == false
        {
            if let refreshedToken = FIRInstanceID.instanceID().token()
            {
                self.DeviceRegistrationForServer(DeviceToken: refreshedToken)
                print("InstanceID token: \(refreshedToken)")
            }
        }
        if self.revealViewController() != nil {
            revalMenuButton.target = self.revealViewController()
            revalMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        NotificationCenter.default.addObserver(self, selector: #selector(HomeView.shareAppURLTapped), name: NSNotification.Name(rawValue: "ShareApplicationURL"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeView.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    
    
    
    //MARK:- Device Registration
    func DeviceRegistrationForServer(DeviceToken:String)
    {
        let LoginID:String = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
        let customer : Dictionary = ["DeviceDetailsRequest":["DeviceDetails":["LoginID":LoginID,"DeviceToken":DeviceToken,"OSType":"IOS"]]]
        
        HudBar.sharedInstance.showHudWithMessage(message: "Please wait..", view: self.view)
        ProfileViewInteractor.SharedInstance.delegateProfile = self
        ProfileViewInteractor.SharedInstance.MyDeviceRegistration(params: customer)

    }
//MARK:- DonateAction
    @IBAction func DonateAction(_ sender: Any)
    {
        SingleTon.SharedInstance.isCheckedIndividual = true
        SingleTon.SharedInstance.isCheckedHospital = true
        SingleTon.SharedInstance.isCheckedCamp = true
        
        let donateView = self.storyboard?.instantiateViewController(withIdentifier: "DonateView")
        self.navigationController?.pushViewController(donateView!, animated: true)

    }
//MARK:- RequestAction
    @IBAction func RequestAction(_ sender: Any)
    {
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "RequestView")
        self.navigationController?.pushViewController(requestView!, animated: true)
        
    }
//MARK:- MyRequestAction
    @IBAction func MyRequestAction(_ sender: Any)
    {
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestView")
        self.navigationController?.pushViewController(requestView!, animated: true)
    }
    //MARK:- PushNotificationView
    func PushNotificationView(_ notification: NSNotification)
    {
        let dict = notification.object as! Dictionary<String, Any>
       
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .overCurrentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
    }
    //MARK:- Share Application URL With Activity
    func shareAppURLTapped()
    {
        let textToShare = "LifeLine is a social application dedicated to connecting blood banks, donors and recipients."
        let textToIOS = "iOS:- https://goo.gl/XJl5a7"
        let textToAndroid = "Android:- https://goo.gl/PUorhE"
        
        if let myWebsite = NSURL(string: "https://goo.gl/XJl5a7") {
            let objectsToShare = [textToShare,textToIOS,textToAndroid, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
//MARK:- ProtocolBloodInfo
extension HomeView:ProtocolRegisterProfile
{
    func succesfullyRegisterProfile(success: Bool)
    {
        if success == true
        {
            UserDefaults.standard.set(true, forKey: "DeviceRegister")
            HudBar.sharedInstance.hideHudFormView(view: self.view)
           // HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Device Register successfully", view: self.view)
        }else{
            UserDefaults.standard.set(false, forKey: "DeviceRegister")
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Failed to Update", view: self.view)
        }
    }
    func failedRegisterProfile(Response:String)
    {
        UserDefaults.standard.set(false, forKey: "DeviceRegister")
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast("No Internet Connection, please check your Internet Connection", duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast("Unable to access server, please try again later", duration: 3.0, position: .bottom)
        }
    }
}
