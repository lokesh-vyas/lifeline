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
    @IBOutlet weak var lblDoctorName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPersonalAppeal: UILabel!
    @IBOutlet weak var lblContactNumber: UnderlinedLabel!
    @IBOutlet weak var lblHospitalName: UILabel!
    var textShareArray = [String]()
    var textAddress = String()

    var iID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(IndividualConfirmDonate.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        self.navigationController?.completelyTransparentBar()
        IndividualConfirmDonateInteractor.sharedInstance.delegate = self
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)

        //MARK:- Either coming from APN or Back
        if MarkerData.SharedInstance.isIndividualAPN == false {
            //Local steps
            iID = MarkerData.SharedInstance.oneRequestOfDonate["CID"]! as! String
        } else {
            //Through APN
              navigationItem.leftBarButtonItem = nil
        }
        self.IndividualConfirmDonateProperties()
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(IndividualConfirmDonate.lblCallTapped(_:)))
        lblContactNumber.addGestureRecognizer(tapRec)
        lblContactNumber.isUserInteractionEnabled = true
    }
    
    func lblCallTapped(_ sender: UITapGestureRecognizer)
    {
                if let url = URL(string: "tel://\(self.lblContactNumber.text!)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
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
    //MARK:- btnSharedTapped
    @IBAction func btnSharedTapped(_ sender: Any)
    {
        let textShareLink = MultiLanguage.getLanguageUsingKey("REQUEST_SHARE_TITLE_MESSAGE")
        let textToIOS = "iOS:- https://goo.gl/XJl5a7"
        let textToAndroid = "Android:- https://goo.gl/PUorhE"
        
        if let myWebsite = NSURL(string: "https://goo.gl/XJl5a7") {
            let objectsToShare = [MultiLanguage.getLanguageUsingKey("REQUEST_VOLUNTEER_SHARE_MESSAGE"),textShareArray[0],textShareArray[1],textShareArray[2],textShareArray[3],textShareArray[4],textShareLink,textToIOS,textToAndroid,textAddress, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func btnConfirmDonateTapped(_ sender: Any) {

        //MARK:- Below Age 18
        let data = UserDefaults.standard.object(forKey: "ProfileData")
        if data != nil {
            let profileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
            if Int(profileData.Age)! < 18 {
                let alert = UIAlertController(title: MultiLanguage.getLanguageUsingKey("TOAST_WARNIG"), message: MultiLanguage.getLanguageUsingKey("AGE_WARNING_MESSAGE"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_OK"), style: UIAlertActionStyle.default, handler: {action in self.toiConfirmDonateSubmit()}))
                alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_CANCEL"), style: UIAlertActionStyle.destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                self.toiConfirmDonateSubmit()
            }
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
        var lblTitle = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhatNeeded"])
        if lblTitle == "Blood"
        {
            lblTitle = MultiLanguage.getLanguageUsingKey("BLOOD_STRING")
        }
        else if lblTitle == "Plasma"
        {
            lblTitle = MultiLanguage.getLanguageUsingKey("PLASMA_STRING")
        }
        else
        {
            lblTitle = MultiLanguage.getLanguageUsingKey("PLATELETS_STRING")
        }
        
        self.lblWhoRequested.text = "\(lblTitle) \(MultiLanguage.getLanguageUsingKey("REQUIREMENT_STRING")) \(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["BloodGroup"]))"
        
        self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("BLOOD_GROUP")) : \(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["BloodGroup"]))", at: 0)
         self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("BLOOD_REQUIREMENT")) : \(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhatNeeded"]))", at: 1)
        
        self.lblWhenRequired.text = Util.SharedInstance.showingDateToUser(dateString: String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhenNeeded"]))
        
        self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_NEEDED_BY")) : \(Util.SharedInstance.showingDateToUser(dateString: String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhenNeeded"])))", at: 2)
        
        self.lblNoOfUnits.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["NumUnits"])
        self.lblDoctorName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["DoctorName"])
        self.lblPatientName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PatientName"])
        self.lblContactPerson.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactPerson"])
        
        let addressLat = (String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["Latitude"]))
        let addressLong = (String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["Longitude"]))
        self.textAddress = "Location:- https://maps.google.com/?q=@\(addressLat),\(addressLong)"
        
        self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NAME_LBL")) : \(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactPerson"]))", at: 3)
        
        let strContact = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactNumber"])
        if strContact == "null"
        {
            lblContactNumber.text = "00"
            self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NUMBER_LBL")) : 00", at: 4)
        }else
        {
            lblContactNumber.text = strContact
             self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NUMBER_LBL")) : \(strContact)", at: 4)
        }
        
//        self.lblContactNumber.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactNumber"])
        
        self.lblHospitalName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["CollectionCentreName"])
        
        self.lblAddress.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["AddressLine"]).replacingOccurrences(of: "\n", with: ",").appending(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["City"])).appending(" - ").appending(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PINCode"]))
        
        self.lblPersonalAppeal.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PersonalAppeal"])
        HudBar.sharedInstance.hideHudFormView(view: self.view)
    }
    func didFailGetRequestDetails(Response:String) {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
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
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ALREADY_VOLUNTEERED"), duration: 3.0, position: .bottom)
            let tempStr = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["PreferredDateTime"])
            MarkerData.SharedInstance.PreferredDateTime = Util.SharedInstance.dateChangeForUser(dateString: tempStr)
            MarkerData.SharedInstance.CommentLines = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["Comment"])
        }
        
        let alertConfirm = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfirmDonate") as! AlertConfirmDonate
        alertConfirm.checkForDate = "Request"

        alertConfirm.modalPresentationStyle = .overCurrentContext
        alertConfirm.view.backgroundColor = UIColor.clear
        present(alertConfirm, animated: true, completion: nil)
    }
    
    func didFailGetVolunteerDetails(Response:String) {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }    }
}



