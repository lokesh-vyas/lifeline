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
    var requiredDetails = [String : Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblWhoRequested.text = (MarkerData.SharedInstance.oneRequestOfDonate["CName"] as! String?)?.substring(to: 24)
        self.lblWhenRequired.text = (MarkerData.SharedInstance.oneRequestOfDonate["CName"] as! String?)?.substring(from: 27)
        self.lblNoOfUnits.text = self.lblWhoRequested.text?.substring(with: 5..<7)
        self.lblContactPerson.text = MarkerData.SharedInstance.oneRequestOfDonate["UserName"] as! String?
        self.lblContactNumber.text = MarkerData.SharedInstance.oneRequestOfDonate["CContactNumber"] as! String?
        
        IndividualConfirmDonateInteractor.sharedInstance.delegate = self
        let reqUrl = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.GetRequestDetails"
        let reqDetailsBody = ["GetRequestDetailsRequest": [
                                            "RequestDetails": [
                                                    "RequestID": "1"
                                                        ]]]
        IndividualConfirmDonateInteractor.sharedInstance.getRequestDetails(urlString: reqUrl, params: reqDetailsBody)
        
    }

    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnHomeTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnConfirmDonateTapped(_ sender: Any) {
        let strV = "http://demo.frontman.isteer.com:8284/services/GetVolunteerList"
        let volunteerBody = ["GetVolunteerListRequest": [
                                        "RequestDetails": [
                                                    "LoginID":"114177301473189791455",
                                                    "RequestID":"\(MarkerData.SharedInstance.markerData["ID"])"
                                                    ]]]
        
        ConfirmDonateInteractor.sharedInstance.getVolunteerDetails(urlString: strV, params: volunteerBody)
        let alertConfirm = self.storyboard?.instantiateViewController(withIdentifier: "AlertConfirmDonate") as! AlertConfirmDonate
        alertConfirm.modalPresentationStyle = .overCurrentContext
        alertConfirm.view.backgroundColor = UIColor.clear
        present(alertConfirm, animated: true, completion: nil)
        
    }
   }

extension IndividualConfirmDonate : IndividualRequestDetailsProtocol {
    
    func didSuccessGetRequestDetails(jsonArray: JSON) {
        print("<<<<<didSuccess-GetRequestDetails>>>>>", jsonArray)
    }
    func didFailGetRequestDetails() {
        print("<<didFail-GetRequestDetails>>")
    }
}

extension IndividualConfirmDonate : getVolunteerProtocol {
    
    func didSuccessGetVolunteerDetails(jsonArray: JSON) {
        print("<<<<<didSuccess-GetVolunteerDetails>>>>>", jsonArray)
    }
    
    func didFailGetVolunteerDetails() {
        print("<<didFail-GetVolunteerDetails>>")
    }
}



extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
