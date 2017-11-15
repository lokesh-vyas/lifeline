//
//  MyRequestView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyRequestView: UIViewController {
    
    @IBOutlet weak var lblInternetIssue: UILabel!
    @IBOutlet weak var tableRequestView: UITableView!
    var MyRequestArray = Array<JSON>()
    var MyDonorsArray = Array<JSON>()
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableRequestView.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        
        tableRequestView.isHidden = true
        lblInternetIssue.isHidden = true
        self.MyRequestServiceCall()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyRequestView.MyRequestServiceCall), name: NSNotification.Name(rawValue: "MyRequestServiceCallUpdate"), object: nil)
    }
    //MARK:- MyRequestServiceCall
    func MyRequestServiceCall()
    {
        let LoginID:String
            = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        MyRequestInteractor.SharedInstance.delegate = self
        MyRequestInteractor.SharedInstance.MyRequestServiceCall(loginID: LoginID)
    }
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- BackButton
    @IBAction func BackButton(_ sender: Any)
    {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    
}
//MARK:- TableViewDelegate
extension MyRequestView:UITableViewDelegate,UITableViewDataSource
{
    //MARK: btnCloseTapped
    func btnCloseTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        let myRequestDetail = MyRequestArray[buttonRow]
        let requestViewClose:MyRequestClose = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestClose") as! MyRequestClose
        requestViewClose.MyRequestCloseJSON = myRequestDetail
        requestViewClose.StringForCheckView = "MyRequest"
        requestViewClose.modalPresentationStyle = .overCurrentContext
        requestViewClose.modalTransitionStyle = .coverVertical
        requestViewClose.view.backgroundColor = UIColor.clear
        self.present(requestViewClose, animated: true, completion: nil)
    }
    //MARK: btnDonorViewTapped
    func btnDonorViewTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        let myRequestDetail = MyRequestArray[buttonRow]
        let donorView:MyDonorView = self.storyboard?.instantiateViewController(withIdentifier: "MyDonorView") as! MyDonorView
        donorView.MyRequestCloseJSON = myRequestDetail
        donorView.MyStringForCheck = "MyRequest"
        self.navigationController?.pushViewController(donorView, animated: true)
    }
    func viewCloseTapped(_ sender: UITapGestureRecognizer)
    {
        let button = sender.view?.tag
        let myRequestDetail = MyRequestArray[button!]
        let requestViewClose:MyRequestClose = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestClose") as! MyRequestClose
        requestViewClose.MyRequestCloseJSON = myRequestDetail
        requestViewClose.StringForCheckView = "MyRequest"
        requestViewClose.modalPresentationStyle = .overCurrentContext
        requestViewClose.modalTransitionStyle = .coverVertical
        requestViewClose.view.backgroundColor = UIColor.clear
        self.present(requestViewClose, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if MyRequestArray.count < 1 {
            tableRequestView.isHidden = true
            lblInternetIssue.isHidden = false
            lblInternetIssue.text = MultiLanguage.getLanguageUsingKey("NO_REQUEST_FOUND")
        }
        lblInternetIssue.isHidden = true
        tableRequestView.isHidden = false
        return MyRequestArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
                var cell:MyRequestCell? = tableRequestView.dequeueReusableCell(withIdentifier: "MyRequestCell") as? MyRequestCell
                if cell == nil
                {
                    let nib:Array = Bundle.main.loadNibNamed("MyRequestCell", owner: self, options: nil)!
                    cell = nib[0] as? MyRequestCell
                }
                cell?.viewBackground.completelyTransparentView()
                let myRequestDetail = MyRequestArray[indexPath.row]
        if (myRequestDetail["DonorsDetails"].dictionary != nil)
        {
            var MyDonorsArray1 = myRequestDetail["DonorsDetails"]["DonorDetails"]
            if (MyDonorsArray1.dictionary) != nil
            {
                MyDonorsArray1 = JSON.init(arrayLiteral: MyDonorsArray1)
            }
            if MyDonorsArray1.count > 0 {
                cell?.lblDonorCount.text = "\(MyDonorsArray1.count) Donors"
            }
            else {
                cell?.lblDonorCount.text = "No Donors"
            }
        }
        else
        {
            cell?.lblDonorCount.text = "No Donors"
        }
                cell?.lblPatientName.text = myRequestDetail["PatientName"].string
                cell?.lblBloodGroup.text = myRequestDetail["BloodGroup"].string
                cell?.lblRequestDate.text = "Needed By \(Util.SharedInstance.dateChangeForGetProfileDOB(dateString: myRequestDetail["WhenNeeded"].string!))"
                if myRequestDetail["Status"].string == "Close"
                {
                    cell?.btnCloseRequest.isHidden = true
                }
                else
                {
                    cell?.btnCloseRequest.isHidden = false
                }
        
                cell?.btnCloseRequest.tag = indexPath.row
                cell?.btnCloseRequest.addTarget(self, action: #selector(MyRequestView.btnCloseTapped(sender:)), for: .touchUpInside)
        
                cell?.btnViewDonars.tag = indexPath.row
                cell?.btnViewDonars.addTarget(self, action: #selector(MyRequestView.btnDonorViewTapped(sender:)), for: .touchUpInside)
                return cell!
    }
}
//MARK:- MyRequestProtocol
extension MyRequestView:MyRequestProtocol
{
    func SuccessMyRequest(JSONResponse: JSON,Sucess:Bool)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Sucess == true
        {
            self.tableRequestView.isHidden = false
            self.lblInternetIssue.isHidden = true
            var dataArray = JSONResponse["MyRequestsResponse"]["ResponseDetails"]
            if (dataArray.dictionary) != nil
            {
                dataArray = JSON.init(arrayLiteral: dataArray)
            }
            
            if let temp = dataArray.array {
                MyRequestArray = temp
            } else {
                self.tableRequestView.isHidden = true
                self.lblInternetIssue.isHidden = false
                self.lblInternetIssue.text = MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING")
                //Here we found nil
                return
            }
            self.tableRequestView.performSelector(onMainThread: #selector(self.tableRequestView.reloadData), with: nil, waitUntilDone: true)
        }
        else
        {
            self.tableRequestView.isHidden = true
            self.lblInternetIssue.isHidden = false
            self.lblInternetIssue.text = MultiLanguage.getLanguageUsingKey("NO_REQUEST_FOUND")
        }
    }
    func FailMyRequest(Response:String)
    {
        self.tableRequestView.isHidden = true
        self.lblInternetIssue.isHidden = false
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
