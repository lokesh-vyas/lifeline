//
//  ConfirmDonate.swift
//  lifeline
//
//  Created by Apple on 28/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class ConfirmDonate: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblWorkingHours: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnConfirmDonate: UIButton!
    @IBOutlet weak var Email: UILabel!
    @IBOutlet weak var FromDate: UILabel!
    @IBOutlet weak var ToDate: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var VolunteerDetails: UILabel!
    @IBOutlet weak var lblCampDescription: UILabel!
    @IBOutlet weak var HospitalName: UILabel!
    
    @IBOutlet var BarBtnHome: UIBarButtonItem!
    @IBOutlet var btnShare: UIBarButtonItem!
    var ID = String()
    var fromDateCamp:NSDate?
    var toDateCamp:NSDate?
    var checkForString = String()
    var textShareArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        ConfirmDonateInteractor.sharedInstance.delegate = self
        navigationItem.rightBarButtonItem = nil
        //MARK:- Invokes to add properties on controller
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmDonate.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        //MARK:- Either coming from APN or Back
        if MarkerData.SharedInstance.isNotIndividualAPN == false || MarkerData.SharedInstance.isIndividualAPN == false {
            //local
            ID = (MarkerData.SharedInstance.markerData["ID"] as! String?)!
            self.confirmDonateProperties()
        } else {
             HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: view)
            //Through APN
            navigationItem.rightBarButtonItems = [btnShare,BarBtnHome]
            navigationItem.leftBarButtonItem = nil
            HospitalName.text = MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NAME_LBL")
            Email.isHidden = false
            lblEmailID.isHidden = false
            FromDate.isHidden = false
            lblFromDate.isHidden = false
            ToDate.isHidden = false
            lblToDate.isHidden = false
            VolunteerDetails.isHidden = false
            lblCampDescription.isHidden = false
            btnConfirmDonate.setTitle(MultiLanguage.getLanguageUsingKey("CAMP_VOLUNTEER"), for: .normal)
            let bodyGetCampDetails = ["CampaignDetailsRequest" : [
                "RequestDetails" : [
                    "LoginID": "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                    "CampaignID": ID
                ]]]
            
            //MARK:- GET COMPAIGN DETAILS
            ConfirmDonateInteractor.sharedInstance.getCompaignDetails(urlString: URLList.GET_CAMPAGIN_DETAILS.rawValue, params: bodyGetCampDetails)
            
        }
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(ConfirmDonate.lblCallTapped(_:)))
        lblContactNumber.addGestureRecognizer(tapRec)
        lblContactNumber.isUserInteractionEnabled = true
        let tapEmailRec = UITapGestureRecognizer(target: self, action: #selector(ConfirmDonate.lblEmailTapped(_:)))
        lblEmailID.addGestureRecognizer(tapEmailRec)
        lblEmailID.isUserInteractionEnabled = true
    }
    
    func lblCallTapped(_ sender: UITapGestureRecognizer)
    {
        let phoneNumber: String
        let formatedNumber: String
        if(MarkerData.SharedInstance.markerData["ContactNumber"] != nil)
        {
            phoneNumber = String(describing: MarkerData.SharedInstance.markerData["ContactNumber"])
            print("Requester phone number is : \(phoneNumber)")
            formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            print("calling \(formatedNumber)")
        }
        else
        {
            phoneNumber = (MarkerData.SharedInstance.markerData["ContactNumber"] as! String)
            print("Requester phone number is : \(phoneNumber)")
            formatedNumber = phoneNumber.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            print("calling \(formatedNumber)")
        }
        if let url = URL(string: "tel://\(formatedNumber)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    func lblEmailTapped(_ sender: UITapGestureRecognizer)
    {
        let emailAddress = MarkerData.SharedInstance.markerData["Email"]
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients([emailAddress as! String])
            mailVC.setSubject("")
            mailVC.setMessageBody("", isHTML: true)
            self.present(mailVC, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: MultiLanguage.getLanguageUsingKey("MAIL_SEND_CANCEL"), message: MultiLanguage.getLanguageUsingKey("MAIL_CANCEL_MESSAGE"), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_OK"), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- btnShareTapped
    @IBAction func btnShareTapped(_ sender: Any)
    {
        
        let textShareLink = MultiLanguage.getLanguageUsingKey("REQUEST_SHARE_TITLE_MESSAGE")
        let textToIOS = "iOS:- https://goo.gl/XJl5a7"
        let textToAndroid = "Android:- https://goo.gl/PUorhE"
        
        if let myWebsite = NSURL(string: "https://goo.gl/XJl5a7") {
            let objectsToShare = [MultiLanguage.getLanguageUsingKey("REQUEST_CAMP_VOLUNTEER_SHARE_MESSAGE"),textShareArray[0],textShareArray[1],textShareArray[2],textShareArray[3],textShareLink,textToIOS,textToAndroid, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
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
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnHomeTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealView, animated: true, completion: nil)
    }

    @IBAction func btnConfirmDonateTapped(_ sender: Any) {
        
        
        
        //MARK:- Below Age 18
        let data = UserDefaults.standard.object(forKey: "ProfileData")
        if data != nil {
            let profileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
            if Int(profileData.Age)! < 18 {
                let alert = UIAlertController(title: MultiLanguage.getLanguageUsingKey("TOAST_WARNIG"), message: MultiLanguage.getLanguageUsingKey("AGE_WARNING_MESSAGE"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_OK"), style: .default, handler: { action in self.toConfirmDonateSubmit()}))
                alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_CANCEL"), style: .destructive, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                self.toConfirmDonateSubmit()
            }
        }
    }
    
    func toConfirmDonateSubmit()  {
        
        var whichID = String()
        var idValue = String()
        
        MarkerData.SharedInstance.oneRequestOfDonate["CID"] = nil
        if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "1"
        {
            if MarkerData.SharedInstance.markerData["IndividualDetails"] as! String != "null" { // Individual
                whichID = "RequestID"
                 checkForString = "RequestID"
            } else { // Hospital
                whichID = "CenterID"
                checkForString = "CenterID"
            }
        } else if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "2" { // Camp
            whichID = "CampaignID"
            checkForString = "Campaign"
            if self.lblFromDate.text != nil
            {
                let workingHours:String = MarkerData.SharedInstance.markerData["WorkingHours"] as! String
                let fullNameArr : [String] = workingHours.components(separatedBy: "To")
                var fromTime: String? = fullNameArr[0]
                var toTimeO: String? = fullNameArr[1]
                if fromTime == nil
                {
                    fromTime = "09:00"
                }
                if toTimeO == nil
                {
                    toTimeO = "05:00"
                }
                let toDateWithTime:String = (self.lblToDate.text!).appending(" ").appending(toTimeO!)
                let fromDateWithTime:String = (self.lblFromDate.text!).appending(" ").appending(fromTime!)
                
                fromDateCamp = Util.SharedInstance.dateChangeForFromDateInCamp(dateString: fromDateWithTime) as NSDate
                toDateCamp = Util.SharedInstance.dateChangeForFromDateInCamp(dateString: toDateWithTime) as NSDate
            
                
            }else
            {
                checkForString = "CenterID"
            }
            if fromDateCamp == nil
            {
                checkForString = "CenterID"
            }
        }
        idValue = ID
        
        let volDict = ["GetVolunteerListRequest": [
            "RequestDetails": [
                "LoginID" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                "\(whichID)":"\(idValue)"
            ]]]
        ConfirmDonateInteractor.sharedInstance.delegateV = self
        ConfirmDonateInteractor.sharedInstance.getVolunteerDetails(urlString: URLList.LIFELINE_Get_VolunteerList.rawValue, params: volDict)
    }
    
    func confirmDonateProperties() {
        
        lblName.text = MarkerData.SharedInstance.markerData["Name"] as! String?
        lblWorkingHours.text = MarkerData.SharedInstance.markerData["WorkingHours"] as! String?
        let strContact = MarkerData.SharedInstance.markerData["ContactNumber"] as! String?
        if strContact == "null"
        {
            lblContactNumber.text = "00"
        }else
        {
            lblContactNumber.text = strContact
        }
        
       // lblContactNumber.text = MarkerData.SharedInstance.markerData["ContactNumber"] as! String?
        lblEmailID.text = MarkerData.SharedInstance.markerData["Email"] as! String?
        lblFromDate.text = MarkerData.SharedInstance.markerData["FromDate"] as! String?
        lblToDate.text = MarkerData.SharedInstance.markerData["ToDate"] as! String?
        lblAddress.text = (MarkerData.SharedInstance.markerData["AddressLine"] as! String?)?.replacingOccurrences(of: "\n", with: ", ").appending(MarkerData.SharedInstance.markerData["City"] as! String).appending(" - ").appending(MarkerData.SharedInstance.markerData["PINCode"] as! String)
        
        if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "2" { // this is camp
            HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: view)
//            let urlGetCampDetails = "http://demo.frontman.isteer.com:8284/services/LifeLine.GetCampaignDetails"
            //FIXME:- LoginID
            let bodyGetCampDetails = ["CampaignDetailsRequest" : [
                                                    "RequestDetails" : [
                                                            "LoginID": "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                                                            "CampaignID": ID
                                            ]]]
            
            //MARK:- GET COMPAIGN DETAILS
            ConfirmDonateInteractor.sharedInstance.getCompaignDetails(urlString: URLList.GET_CAMPAGIN_DETAILS.rawValue, params: bodyGetCampDetails)
            HospitalName.text = MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NAME_LBL")
            Email.isHidden = false
            lblEmailID.isHidden = false
            FromDate.isHidden = false
            lblFromDate.isHidden = false
            ToDate.isHidden = false
            lblToDate.isHidden = false
            VolunteerDetails.isHidden = false
            lblCampDescription.isHidden = false
            btnConfirmDonate.setTitle(MultiLanguage.getLanguageUsingKey("CAMP_VOLUNTEER"), for: .normal)
            navigationItem.rightBarButtonItems = [btnShare,BarBtnHome]
            
        } else {
            navigationItem.rightBarButtonItem = BarBtnHome
            HospitalName.text = MultiLanguage.getLanguageUsingKey("HOSPITAL_NAME_LBL")
            Email.isHidden = true
            lblEmailID.isHidden = true
            FromDate.isHidden = true
            lblFromDate.isHidden = true
            ToDate.isHidden = true
            lblToDate.isHidden = true
            VolunteerDetails.isHidden = true
            lblCampDescription.isHidden = true
        }
    }
 }

extension ConfirmDonate : ConfirmDonateProtocol {
    
    func didSuccessGetCompaignDetails(jsonArray: JSON)
    {
        
        print("*****didSuccess-GetCompaignDetails******", jsonArray)
        MarkerData.SharedInstance.APNResponse = jsonArray["CampaignDetailsResponse"]["ResponseDetails"].dictionaryObject!
        MarkerData.SharedInstance.isAPNCamp = true
//        self.lblToDate.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"]).characters.count > 10 ?  String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"]).substring(to: 10):String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"])
//        
//        self.lblFromDate.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["FromDate"]).characters.count > 10 ?  String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["FromDate"]).substring(to: 10):String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["FromDate"])
        
        
        self.lblCampDescription.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["AdditionalInfo"])
        
        lblName.text = MarkerData.SharedInstance.APNResponse["Name"] as! String?
        self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NAME_LBL")) : \(lblName.text!)", at: 0)
        
        let strContact = String(describing: MarkerData.SharedInstance.APNResponse["ContactNumber"]!)
        if strContact == "null"
        {
            lblContactNumber.text = "00"
            self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NUMBER_LBL")) : 00", at: 1)
        }else
        {
            lblContactNumber.text = strContact
            self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_CONTACT_NUMBER_LBL")) : \(strContact)", at: 1)
        }
        lblWorkingHours.text = MarkerData.SharedInstance.APNResponse["WorkingHours"] as! String?
        
        self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_WORKING_HOURS")) : \(lblWorkingHours.text!)", at: 2)
        
        lblFromDate.text = Util.SharedInstance.showingDateToUser(dateString: (String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["FromDate"]).characters.count > 10 ?  String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["FromDate"]).substring(to: 10):String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["FromDate"])))
        lblToDate.text = Util.SharedInstance.showingDateToUser(dateString: (String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"]).characters.count > 10 ?  String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"]).substring(to: 10):String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"])))
        
        self.textShareArray.insert("\(MultiLanguage.getLanguageUsingKey("HOSPITAL_NEEDED_BY")) : \(lblToDate.text!)", at: 3)

        lblEmailID.text = MarkerData.SharedInstance.APNResponse["Email"] as! String?
        lblAddress.text =  (MarkerData.SharedInstance.APNResponse["AddressLine"] as! String?)?.replacingOccurrences(of: "\n", with: ", ").appending(MarkerData.SharedInstance.APNResponse["City"] as! String).appending(" - ").appending(String(describing : MarkerData.SharedInstance.APNResponse["PINCode"]!))
        
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        
    }
    func didFailGetCompaignDetails(Response:String) {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}

extension ConfirmDonate : getVolunteerProtocol {
    func didSuccessGetVolunteerDetails(jsonArray: JSON) {
        //TODO:- true= comment & preferred date false= no vol
        print("*****didSuccessGetVolunteerDetails******", jsonArray)
        
        if jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["StatusCode"] == 1 {
            
            MarkerData.SharedInstance.PreferredDateTime = nil
            MarkerData.SharedInstance.CommentLines = nil
            
        } else {
            let tempStr = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["PreferredDateTime"])
            MarkerData.SharedInstance.PreferredDateTime = Util.SharedInstance.dateChangeForUser(dateString: tempStr)
            MarkerData.SharedInstance.CommentLines = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["Comment"])
            
        }
        
        let alertConfirm = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfirmDonate") as! AlertConfirmDonate
        alertConfirm.checkForDate = checkForString
        if fromDateCamp != nil
        {
            alertConfirm.fromDate = fromDateCamp!
            alertConfirm.toDate = toDateCamp!
        }
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

extension ConfirmDonate : MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate
{
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch (result)
        {
        case MFMailComposeResult.cancelled:
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("MAIL_CANCEL"), duration: 2.0, position: .bottom)
            break;
        case MFMailComposeResult.saved:
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("MAIL_IN_DRAFT"), duration: 2.0, position: .bottom)
            break;
        case MFMailComposeResult.sent:
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("MAIL_SENT_SUCCESSFULLY"), duration: 2.0, position: .bottom)
            break;
        case MFMailComposeResult.failed:
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("MAIL-FAILED"), duration: 2.0, position: .bottom)
            break;
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
