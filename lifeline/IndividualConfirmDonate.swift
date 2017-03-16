//
//  IndividualConfirmDonate.swift
//  lifeline
//
//  Created by Apple on 28/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class IndividualConfirmDonate: UIViewController {

    @IBOutlet weak var lblWhoRequested: UILabel!
    @IBOutlet weak var lblWhenRequired: UILabel!
    @IBOutlet weak var lblNoOfUnits: UILabel!
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblContactPerson: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPersonalAppeal: UILabel!
    
    var iID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(IndividualConfirmDonate.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        self.navigationController?.completelyTransparentBar()
        IndividualConfirmDonateInteractor.sharedInstance.delegate = self
        HudBar.sharedInstance.showHudWithMessage(message: "Loading...", view: self.view)

        //MARK:- Either coming from APN or Back
        if MarkerData.SharedInstance.isIndividualAPN == false {
            //Local steps
            iID = MarkerData.SharedInstance.oneRequestOfDonate["CID"]! as! String
        } else {
            //Through APN
            navigationItem.hidesBackButton = true
        }
        
        self.IndividualConfirmDonateProperties()
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
    
    @IBAction func btnBackTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        
    }

    @IBAction func btnHomeTapped(_ sender: Any) {
//        self.navigationController?.popToRootViewController(animated: true)
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealView, animated: true, completion: nil)
        
    }
    
    @IBAction func btnConfirmDonateTapped(_ sender: Any) {

        //MARK:- Below Age 18
        let data = UserDefaults.standard.object(forKey: "ProfileData")
        if data != nil {
            let profileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
            if Int(profileData.Age)! < 18 {
                let alert = UIAlertController(title: "Warning", message: "You are not eligible for donating blood as your age is below 18. If you still want to continue, please select OK to continue.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.toiConfirmDonateSubmit()}))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            
        }
    }
    
    func toiConfirmDonateSubmit() {
        
        let volunteerBody = ["GetVolunteerListRequest": [
            "RequestDetails": [
                "LoginID" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                "RequestID" : iID
            ]]]
        
        ConfirmDonateInteractor.sharedInstance.delegateV = self
        ConfirmDonateInteractor.sharedInstance.getVolunteerDetails(urlString: URLList.LIFELINE_Get_VolunteerList.rawValue, params: volunteerBody)
    }
    
    func IndividualConfirmDonateProperties() {
        
        //FIXME:- use WS response
//        let reqUrl = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetRequestDetails"
        //FIXME:- RequestID
        let reqDetailsBody = ["GetRequestDetailsRequest": [
                                            "RequestDetails": [
                                                    "RequestID": iID
                                                        ]]]
        IndividualConfirmDonateInteractor.sharedInstance.getRequestDetails(urlString: URLList.GET_REQUEST_DETAILS.rawValue, params: reqDetailsBody)
        
    }
   }

extension IndividualConfirmDonate : IndividualRequestDetailsProtocol {
    
    func didSuccessGetRequestDetails(jsonArray: JSON) {
        //TODO:- use data
        print("<<<<<didSuccess-GetRequestDetails>>>>>", jsonArray)
           MarkerData.SharedInstance.isAPNCamp = false
        MarkerData.SharedInstance.APNResponse = jsonArray["GetRequestDetailsResponse"]["ResponseDetails"].dictionaryObject!
        self.lblWhoRequested.text = "\(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhatNeeded"])) requirement for \(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["BloodGroup"]))"
        self.lblWhenRequired.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhenNeeded"])
        self.lblNoOfUnits.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["NumUnits"])
        self.lblDoctorName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["DoctorName"])
        self.lblPatientName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PatientName"])
        self.lblContactPerson.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactPerson"])
        self.lblContactNumber.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactNumber"])
        self.lblAddress.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["AddressLine"])
        self.lblPersonalAppeal.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PersonalAppeal"])
        
        HudBar.sharedInstance.hideHudFormView(view: self.view)
    }
    func didFailGetRequestDetails() {
        print("<<didFail-GetRequestDetails>>")

    }
}

extension IndividualConfirmDonate : getVolunteerProtocol {
    
    func didSuccessGetVolunteerDetails(jsonArray: JSON) {
        //TODO:- true false
        print("<<<<<didSuccess-GetVolunteerDetails>>>>>", jsonArray)
        if jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["StatusCode"] == 1 {
            
            MarkerData.SharedInstance.PreferredDateTime = nil
            MarkerData.SharedInstance.CommentLines = nil
            
        }else{
            let tempStr = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["PreferredDateTime"])
            MarkerData.SharedInstance.PreferredDateTime = Util.SharedInstance.dateChangeForUser(dateString: tempStr)
            MarkerData.SharedInstance.CommentLines = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["Comment"])
        }
        
        let alertConfirm = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfirmDonate") as! AlertConfirmDonate
        alertConfirm.modalPresentationStyle = .overCurrentContext
        alertConfirm.view.backgroundColor = UIColor.clear
        present(alertConfirm, animated: true, completion: nil)
        
        
    }
    
    func didFailGetVolunteerDetails() {
        print("<<didFail-GetVolunteerDetails>>")

    }
}



