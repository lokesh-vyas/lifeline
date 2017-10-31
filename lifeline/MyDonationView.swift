//
//  MyDonationView.swift
//  lifeline
//
//  Created by Anjali on 11/10/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyDonationView: UIViewController {

    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var myDonationArray = Array<JSON>()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.contentInset = UIEdgeInsetsMake(-35, 0.0, -20, 0.0)
        tblView.isHidden = true
        lblNoRecordFound.isHidden = true
        self.MyDonationServiceCall()
    }
    //MARK:- MyRequestServiceCall
    func MyDonationServiceCall()
    {
        let LoginID:String
            = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        MyRequestInteractor.SharedInstance.delegate = self
        MyRequestInteractor.SharedInstance.MyDonationServiceCall(loginID: LoginID)
    }
}
extension MyDonationView : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if myDonationArray.count < 1
        {
            tblView.isHidden = true
            lblNoRecordFound.isHidden = false
            lblNoRecordFound.text = MultiLanguage.getLanguageUsingKey("NO_REQUEST_FOUND")
        }
        lblNoRecordFound.isHidden = true
        tblView.isHidden = false
        return myDonationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell:MyDonationCell? = tblView.dequeueReusableCell(withIdentifier: "MyDonationCell") as? MyDonationCell
        if cell == nil
        {
            let nib:Array = Bundle.main.loadNibNamed("MyDonationCell", owner: self, options: nil)!
            cell = nib[0] as? MyDonationCell
        }
        let myDonationDetail = myDonationArray[indexPath.row]
        if String(describing : myDonationDetail["RequestDetails"]) != "null"   // Indi Cell
        {
            
            cell?.lblName.text = myDonationDetail["RequestDetails"]["RequestDetail"]["PatientName"].string
            cell?.lblBloodGroup.text = myDonationDetail["RequestDetails"]["RequestDetail"]["bloodgroup"].string
            cell?.lblRequestDate.text = Util.SharedInstance.dateChangeForGetProfileDOB(dateString: myDonationDetail["RequestDetails"]["RequestDetail"]["WhenNeeded"].string!)
            cell?.imgBloodGroup.image = UIImage(named: "drop_black.png")
        }
        else if String(describing : myDonationDetail["CampDetails"]) != "null"  // Camp Details
        {
            cell?.lblName.text = myDonationDetail["CampDetails"]["CampDetail"]["Name"].string
            cell?.imgBloodGroup.image = UIImage(named: "address_icon.png")
            cell?.lblBloodGroup.text = myDonationDetail["CampDetails"]["CampDetail"]["City"].string
            cell?.lblRequestDate.text = "\(Util.SharedInstance.dateChangeForInternal(dateString: myDonationDetail["CampDetails"]["CampDetail"]["FromDate"].string!)) TO \(Util.SharedInstance.dateChangeForInternal(dateString:  myDonationDetail["CampDetails"]["CampDetail"]["FromDate"].string!))"
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if String(describing : myDonationArray[indexPath.row]["RequestDetails"]) != "null" //Indi Details
        {
            let indconfirmDonate:IndividualConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
            indconfirmDonate.iID = String(describing : myDonationArray[indexPath.row]["RequestDetails"]["RequestDetail"]["RequestID"])
            let rootView:UINavigationController = UINavigationController(rootViewController: indconfirmDonate)
            self.present(rootView, animated: true, completion: nil)
        }
        else if String(describing : myDonationArray[indexPath.row]["CampDetails"]) != "null"  //Camp Details
        {
            let confirmDonate:ConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            confirmDonate.ID = String(describing : myDonationArray[indexPath.row]["CampDetails"]["CampDetail"]["CampaignID"])
            let rootView:UINavigationController = UINavigationController(rootViewController: confirmDonate)
            self.present(rootView, animated: true, completion: nil)
        }
    }
}


//MARK:- MyRequestProtocol
extension MyDonationView:MyRequestProtocol
{
    func SuccessMyRequest(JSONResponse: JSON,Sucess:Bool)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Sucess == true
        {
            self.tblView.isHidden = false
            self.lblNoRecordFound.isHidden = true
            var dataArray = JSONResponse["MyRequestsResponse"]["ResponseDetails"]
            if (dataArray.dictionary) != nil
            {
                dataArray = JSON.init(arrayLiteral: dataArray)
            }
            if let temp = dataArray.array
            {
                myDonationArray = temp
                
            } else
            {
                self.tblView.isHidden = true
                self.lblNoRecordFound.isHidden = false
                self.lblNoRecordFound.text = MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING")
                //Here we found nil
                return
            }
            self.tblView.reloadData()
        }
        else
        {
            self.tblView.isHidden = true
            self.lblNoRecordFound.isHidden = false
            self.lblNoRecordFound.text = MultiLanguage.getLanguageUsingKey("NO_REQUEST_FOUND")
        }
        
    }
    func FailMyRequest(Response:String)
    {
        self.tblView.isHidden = true
        self.lblNoRecordFound.isHidden = false
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}

