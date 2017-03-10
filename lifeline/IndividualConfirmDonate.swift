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
//    var requiredDetails = [String : Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        IndividualConfirmDonateInteractor.sharedInstance.delegate = self
        ConfirmDonateInteractor.sharedInstance.delegateV = self
        
        self.IndividualConfirmDonateProperties()
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
        let strV = "http://demo.frontman.isteer.com:8284/services/GetVolunteerList"
        //FIXME:- LoginID
        let volunteerBody = ["GetVolunteerListRequest": [
                                        "RequestDetails": [
                                                    "LoginID":"114177301473189791455",
                                                    "RequestID":"\(MarkerData.SharedInstance.oneRequestOfDonate["CID"]!)"
                                                    ]]]
        
        ConfirmDonateInteractor.sharedInstance.getVolunteerDetails(urlString: strV, params: volunteerBody)
        let alertConfirm = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfirmDonate") as! AlertConfirmDonate
        alertConfirm.modalPresentationStyle = .overCurrentContext
        alertConfirm.view.backgroundColor = UIColor.clear
        present(alertConfirm, animated: true, completion: nil)
        
    }
    
    func IndividualConfirmDonateProperties() {
        
        
        //FIXME:- use WS response
        let reqUrl = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetRequestDetails"
        //FIXME:- RequestID
        let reqDetailsBody = ["GetRequestDetailsRequest": [
                                            "RequestDetails": [
                                                    "RequestID": "\(MarkerData.SharedInstance.oneRequestOfDonate["CID"]!)"
                                                        ]]]
        IndividualConfirmDonateInteractor.sharedInstance.getRequestDetails(urlString: reqUrl, params: reqDetailsBody)
        
    }
   }

extension IndividualConfirmDonate : IndividualRequestDetailsProtocol {
    
    func didSuccessGetRequestDetails(jsonArray: JSON) {
        //TODO:- use data
        print("<<<<<didSuccess-GetRequestDetails>>>>>", jsonArray)
        self.lblWhoRequested.text = "\(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhatNeeded"])) requirement for \(String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["BloodGroup"]))"
        self.lblWhenRequired.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["WhenNeeded"])
        self.lblNoOfUnits.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["NumUnits"])
        self.lblDoctorName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["DoctorName"])
        self.lblPatientName.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PatientName"])
        self.lblContactPerson.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactPerson"])
        self.lblContactNumber.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["ContactNumber"])
        self.lblAddress.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["AddressLine"])
        self.lblPersonalAppeal.text = String(describing: jsonArray["GetRequestDetailsResponse"]["ResponseDetails"]["PersonalAppeal"])
    }
    func didFailGetRequestDetails() {
        print("<<didFail-GetRequestDetails>>")
        HudBar.sharedInstance.showHudWithMessage(message: "No Internet Connection", view: self.view)
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
            MarkerData.SharedInstance.PreferredDateTime = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["PreferredDateTime"])
            MarkerData.SharedInstance.CommentLines = String(describing: jsonArray["GetVolunteerListsReponse"]["ResponseDetails"]["Comment"])
            
        }
        
    }
    
    func didFailGetVolunteerDetails() {
        print("<<didFail-GetVolunteerDetails>>")
        HudBar.sharedInstance.showHudWithMessage(message: "No Internet Connection", view: self.view)
    }
}



