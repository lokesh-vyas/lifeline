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
    
//    var MarkerData.SharedInstance.markerData = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        ConfirmDonateInteractor.sharedInstance.delegate = self
        ConfirmDonateInteractor.sharedInstance.delegateV = self
        
        //MARK:- Invokes to add properties on controller
        self.confirmDonateProperties()
    
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
        
        if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "1" {
            if MarkerData.SharedInstance.markerData["IndividualDetails"] as! String != "null" { // Individual
                whichID = "RequestID"
                idValue = (MarkerData.SharedInstance.markerData["ID"] as! String?)!
            } else { // Hospital
                whichID = "CenterID"
                idValue = (MarkerData.SharedInstance.markerData["ID"] as! String?)!
            }
            
        } else if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "2" { // Camp
            whichID = "CampaignID"
            idValue = (MarkerData.SharedInstance.markerData["ID"] as! String?)!
        }
        let strV = "http://demo.frontman.isteer.com:8284/services/GetVolunteerList"
        //FIXME:- LoginID
        let volDict = [
            "GetVolunteerListRequest": [
                "RequestDetails": [
                    "LoginID":"114177301473189791455",
                    "\(whichID)":"\(idValue)"         //"RequestID":"","CenterID":""
                    
                ]]]

        ConfirmDonateInteractor.sharedInstance.getVolunteerDetails(urlString: strV, params: volDict)
        let alertConfirm = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfirmDonate") as! AlertConfirmDonate
        alertConfirm.modalPresentationStyle = .overCurrentContext
        alertConfirm.view.backgroundColor = UIColor.clear
        //
        present(alertConfirm, animated: true, completion: nil)
    }
    
    func confirmDonateProperties() {
        
        lblName.text = MarkerData.SharedInstance.markerData["Name"] as! String?
        lblWorkingHours.text = MarkerData.SharedInstance.markerData["WorkingHours"] as! String?
        lblContactNumber.text = MarkerData.SharedInstance.markerData["ContactNumber"] as! String?
        lblEmailID.text = MarkerData.SharedInstance.markerData["Email"] as! String?
        lblFromDate.text = MarkerData.SharedInstance.markerData["FromDate"] as! String?
        lblToDate.text = MarkerData.SharedInstance.markerData["ToDonate"] as! String?
        lblAddress.text = MarkerData.SharedInstance.markerData["AddressLine"] as! String?
        
        if MarkerData.SharedInstance.markerData["TypeOfOrg"] as! String? == "2" { // this is camp
            
            let urlGetCampDetails = "http://demo.frontman.isteer.com:8284/services/LifeLine.GetCampaignDetails"
            //FIXME:- LoginID
            let bodyGetCampDetails = ["CampaignDetailsRequest" : [
                "RequestDetails" : [
                    "LoginID": "114177301473189791455",
                    "CampaignID": MarkerData.SharedInstance.markerData["ID"] as! String?
                ]]]
            //MARK:- GET COMPAIGN DETAILS
            ConfirmDonateInteractor.sharedInstance.getCompaignDetails(urlString: urlGetCampDetails, params: bodyGetCampDetails)
            
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
        self.lblToDate.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["ToDate"])
        self.lblCampDescription.text = String(describing: jsonArray["CampaignDetailsResponse"]["ResponseDetails"]["AdditionalInfo"])
        
        
    }
    func didFailGetCompaignDetails() {
        print("*****didFail-GetCompaignDetails******")
    }
    
}

extension ConfirmDonate : getVolunteerProtocol {
    func didSuccessGetVolunteerDetails(jsonArray: JSON) {
        //TODO:- true= comment & preferred date false= no vol
        print("*****didSuccessGetVolunteerDetails******", jsonArray)
    }
    func didFailGetVolunteerDetails() {
        print("*****didFail-GetVolunteerDetails******")
    }
}
