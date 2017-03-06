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
    
    var DonateDetails = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        
        ConfirmDonateInteractor.sharedInstance.delegate = self
        ConfirmDonateInteractor.sharedInstance.delegateV = self
        //FIXME: Instance Dictionary can be removed
        DonateDetails = MarkerData.SharedInstance.markerData
        lblName.text = DonateDetails["Name"] as! String?
        lblWorkingHours.text = DonateDetails["WorkingHours"] as! String?
        lblContactNumber.text = DonateDetails["ContactNumber"] as! String?
        lblEmailID.text = DonateDetails["Email"] as! String?
        lblFromDate.text = DonateDetails["FromDate"] as! String?
        lblToDate.text = DonateDetails["ToDonate"] as! String?
        lblAddress.text = DonateDetails["AddressLine"] as! String?
        
        
        if DonateDetails["TypeOfOrg"] as! String? == "2" { // this is camp
            
            let urlGetCampDetails = "http://demo.frontman.isteer.com:8284/services/LifeLine.GetCampaignDetails"
            let bodyGetCampDetails = ["CampaignDetailsRequest" : [
                                                    "RequestDetails" : [
                                                        "LoginID": "114177301473189791455",
                                                        "CampaignID": DonateDetails["ID"] as! String?
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
    
    @IBAction func btnBackTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnHomeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func btnConfirmDonateTapped(_ sender: Any) {
        
        //TODO: where I am coming from H/C/I
        var whichID = String()
        var idValue = String()
        
        if DonateDetails["TypeOfOrg"] as! String? == "1" {
            if DonateDetails["IndividualDetails"] as! String != "null" { // Individual
                whichID = "RequestID"
                idValue = (DonateDetails["ID"] as! String?)!
            } else { // Hospital
                whichID = "CenterID"
                idValue = (DonateDetails["ID"] as! String?)!
            }
            
        } else if DonateDetails["TypeOfOrg"] as! String? == "2" { // Camp
            whichID = "CampaignID"
            idValue = (DonateDetails["ID"] as! String?)!
        }
        let strV = "http://demo.frontman.isteer.com:8284/services/GetVolunteerList"
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
 }

extension ConfirmDonate : ConfirmDonateProtocol {
    
    func didSuccessGetCompaignDetails(jsonArray: JSON) {
        print("*****didSuccess-GetCompaignDetails******", jsonArray)
    }
    func didFailGetCompaignDetails() {
        print("*****didFail-GetCompaignDetails******")
    }
    
}

extension ConfirmDonate : getVolunteerProtocol {
    func didSuccessGetVolunteerDetails(jsonArray: JSON) {
        print("*****didSuccessGetVolunteerDetails******", jsonArray)
    }
    func didFailGetVolunteerDetails() {
        print("*****didFail-GetVolunteerDetails******")
    }
}
