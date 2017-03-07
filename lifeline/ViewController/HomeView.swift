//
//  HomeView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import Firebase

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
    }
    //MARK:- Device Registration
    func DeviceRegistrationForServer(DeviceToken:String)
    {
        let LoginID:String = "734258020038958"
        let customer : Dictionary = ["DeviceDetailsRequest":["DeviceDetails":["LoginID":LoginID,"DeviceToken":DeviceToken,"OSType":"IOS"]]]
        
        HudBar.sharedInstance.showHudWithMessage(message: "Please wait..", view: self.view)
        ProfileViewInteractor.SharedInstance.delegateProfile = self
        ProfileViewInteractor.SharedInstance.MyDeviceRegistration(params: customer)

    }
//MARK:- DonateAction
    @IBAction func DonateAction(_ sender: Any)
    {
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
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Device Register successfully", view: self.view)
        }else{
             UserDefaults.standard.set(false, forKey: "DeviceRegister")
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Failed to Update", view: self.view)
        }
    }
    func failedRegisterProfile()
    {
        UserDefaults.standard.set(false, forKey: "DeviceRegister")
        HudBar.sharedInstance.hideHudFormView(view: self.view)
    }
}
