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
    
    @IBOutlet weak var lblDonate: UILabel!
    @IBOutlet weak var lblRequest: UILabel!
    @IBOutlet weak var revalMenuButton: UIBarButtonItem!
    
    var NotificationList : [Dictionary<String, Any>] = []
    var badgeCount = Int()
    let label = UILabel(frame: CGRect(x: 14, y: -7, width: 18, height: 18))
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
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(HomeView.lblDonateTapped(_:)))
        lblDonate.addGestureRecognizer(tapRec)
        lblDonate.isUserInteractionEnabled = true
        
        let tapRec1 = UITapGestureRecognizer(target: self, action: #selector(HomeView.lblRequestTapped(_:)))
        lblRequest.addGestureRecognizer(tapRec1)
        lblRequest.isUserInteractionEnabled = true
        
       /* self.showBadge()
        // button
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 22))
        rightButton.setBackgroundImage(UIImage(named: "notification"), for: .normal)
        rightButton.addTarget(self, action: #selector(BtnNotificationTapped), for: .touchUpInside)
        rightButton.addSubview(label)
        
        // Bar button item
        let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
        
        navigationItem.rightBarButtonItem = rightBarButtomItem*/
    }
    
    /*func showBadge()
    {
        let storeDataFetch = UserDefaults.standard.object(forKey: "AllNotification")
        if storeDataFetch != nil {
            NotificationList  = storeDataFetch as! [Dictionary<String, Any>]
        }
        for i in 0..<NotificationList.count
        {
            if (NotificationList[i]["Is_Read"] as! String == "0")
            {
                badgeCount = badgeCount + 1
            }
            else if (NotificationList[i]["Is_Read"] as! String == "1")
            {
                badgeCount = badgeCount - 1
            }
        }
        
        //MARK:- Notifications Count
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.textColor = .white
        label.backgroundColor = .red
        if badgeCount <= 0
        {
            label.isHidden = true
        }
        else
        {
            label.text = String(describing: badgeCount)
        }
    }
    
    func BtnNotificationTapped() {
        print("Notification Button Tapped")
        let notificationView = self.storyboard?.instantiateViewController(withIdentifier: "MyNotificationView")
        self.navigationController?.pushViewController(notificationView!, animated: true)
    }*/
    
    func lblDonateTapped(_ sender: UITapGestureRecognizer)
    {
        SingleTon.SharedInstance.isCheckedIndividual = true
        SingleTon.SharedInstance.isCheckedHospital = true
        SingleTon.SharedInstance.isCheckedCamp = true
        
        let donateView = self.storyboard?.instantiateViewController(withIdentifier: "DonateView")
        self.navigationController?.pushViewController(donateView!, animated: true)
    }

    func lblRequestTapped(_ sender: UITapGestureRecognizer)
    {
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "RequestView")
        self.navigationController?.pushViewController(requestView!, animated: true)
    }
    
    //MARK:- Device Registration
    func DeviceRegistrationForServer(DeviceToken:String)
    {
        let LoginID:String = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
        let customer : Dictionary = ["DeviceDetailsRequest":["DeviceDetails":["LoginID":LoginID,"DeviceToken":DeviceToken,"OSType":"IOS"]]]
        
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("Please wait.."), view: self.view)
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
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "MasterRequestVC")
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
        let textToShare = MultiLanguage.getLanguageUsingKey("SOCAIL_SHARE_TITLE_MESSAGE")
        let textToIOS = "iOS:- https://goo.gl/XJl5a7"
        let textToAndroid = "Android:- https://goo.gl/PUorhE"
        
        if let myWebsite = NSURL(string: "https://goo.gl/XJl5a7") {
            let objectsToShare = [textToShare,textToIOS,textToAndroid, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                    
                   if UIDevice.current.userInterfaceIdiom == .pad
                    {
                        if activityVC.responds(to: #selector(getter: UIViewController.popoverPresentationController))
                        {
                            activityVC.popoverPresentationController?.sourceView = self.view
                        }
                    }
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
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("ERROR_PROFILE_UPDATE"), view: self.view)
        }
    }
    func failedRegisterProfile(Response:String)
    {
        UserDefaults.standard.set(false, forKey: "DeviceRegister")
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
