//
//  ConfirmDonate.swift
//  lifeline
//
//  Created by Apple on 28/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    var ID = String()
    
//    var MarkerData.SharedInstance.markerData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        
        ConfirmDonateInteractor.sharedInstance.delegate = self
        
        //MARK:- Invokes to add properties on controller
        self.confirmDonateProperties()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmDonate.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        
        //MARK:- Either coming from APN or Back
        if MarkerData.SharedInstance.isNotIndividualAPN == false || MarkerData.SharedInstance.isIndividualAPN == false {
            //local
            ID = (MarkerData.SharedInstance.markerData["ID"] as! String?)!
        } else {
            //Through APN
            navigationItem.hidesBackButton = true
            
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
//        dismiss(animated: true, completion: nil)
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealView, animated: true, completion: nil)
        
    }
    

    @IBAction func btnConfirmDonateTapped(_ sender: Any) {
        
        //TODO: where I am coming from H/C/I
        var whichID = String()
        var idValue = String()
        MarkerData.SharedInstance.oneRequestOfDonate["CID"] = nil
        
        if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "1" {
            if MarkerData.SharedInstance.markerData["IndividualDetails"] as! String != "null" { // Individual
                whichID = "RequestID"
            } else { // Hospital
                whichID = "CenterID"
            }
            
        } else if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "2" { // Camp
            whichID = "CampaignID"
            
        }
        idValue = ID
//        let strV = "http://demo.frontman.isteer.com:8284/services/GetVolunteerList"
        //FIXME:- LoginID
        let volDict = ["GetVolunteerListRequest": [
                                        "RequestDetails": [
                                        "LoginID" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                                        "\(whichID)":"\(idValue)"
                    ]]]
        
        ConfirmDonateInteractor.sharedInstance.delegateV = self
        ConfirmDonateInteractor.sharedInstance.getVolunteerDetails(urlString: URLList.LIFELINE_Get_VolunteerList.rawValue, params: volDict)
        
        //MARK:- Below Age 18
        let data = UserDefaults.standard.object(forKey: "ProfileData")
        if data != nil {
            let profileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
            if Int(profileData.Age)! < 18 {
                    let alert = UIAlertController(title: "Warning", message: "You're under Age", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
        }
    }
    
    func confirmDonateProperties() {
        
        lblName.text = MarkerData.SharedInstance.markerData["Name"] as! String?
        lblWorkingHours.text = MarkerData.SharedInstance.markerData["WorkingHours"] as! String?
        lblContactNumber.text = MarkerData.SharedInstance.markerData["ContactNumber"] as! String?
        lblEmailID.text = MarkerData.SharedInstance.markerData["Email"] as! String?
        lblFromDate.text = MarkerData.SharedInstance.markerData["FromDate"] as! String?
        lblToDate.text = MarkerData.SharedInstance.markerData["ToDate"] as! String?
        lblAddress.text = MarkerData.SharedInstance.markerData["AddressLine"] as! String?
        
        if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "2" { // this is camp
            HudBar.sharedInstance.showHudWithMessage(message: "Loading...", view: view)
//            let urlGetCampDetails = "http://demo.frontman.isteer.com:8284/services/LifeLine.GetCampaignDetails"
            //FIXME:- LoginID
            let bodyGetCampDetails = ["CampaignDetailsRequest" : [
                                                    "RequestDetails" : [
                                                            "LoginID": "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)",
                                                            "CampaignID": ID
                                            ]]]
            
            //MARK:- GET COMPAIGN DETAILS
            ConfirmDonateInteractor.sharedInstance.getCompaignDetails(urlString: URLList.GET_CAMPAGIN_DETAILS.rawValue, params: bodyGetCampDetails)
            HospitalName.text = "Contact Name"
            Email.isHidden = false
            lblEmailID.isHidden = false
            FromDate.isHidden = false
            lblFromDate.isHidden = false
            ToDate.isHidden = false
            lblToDate.isHidden = false
            VolunteerDetails.isHidden = false
            lblCampDescription.isHidden = false
            btnConfirmDonate.setTitle("Volunteer", for: .normal)
            
        } else {
            
            HospitalName.text = "Hospital Name"
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
    
    func didSuccessGetCompaignDetails(jsonArray: JSON) {
        
        print("*****didSuccess-GetCompaignDetails******", jsonArray)
        self.lblToDate.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"]).characters.count > 10 ?  String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"]).substring(to: 10):String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"])
        //FIXME:- with APNResponse
        self.lblCampDescription.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["AdditionalInfo"])
        
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        
    }
    func didFailGetCompaignDetails() {
        print("*****didFail-GetCompaignDetails******")
        HudBar.sharedInstance.hideHudFormView(view: self.view)
//        HudBar.sharedInstance.showHudWithMessage(message: "No Internet Connection", view: self.view)
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
        alertConfirm.modalPresentationStyle = .overCurrentContext
        alertConfirm.view.backgroundColor = UIColor.clear
        present(alertConfirm, animated: true, completion: nil)
    }
    func didFailGetVolunteerDetails() {
        print("*****didFail-GetVolunteerDetails******")
//        HudBar.sharedInstance.showHudWithMessage(message: "No Internet Connection", view: self.view)
    }
}
