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
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        tableRequestView.contentInset = UIEdgeInsetsMake(-35, 0.0, -20, 0.0)
        tableRequestView.isHidden = true
        lblInternetIssue.isHidden = true
        
        HudBar.sharedInstance.showHudWithMessage(message: "Loading..", view: self.view)
        MyRequestInteractor.SharedInstance.delegate = self
        MyRequestInteractor.SharedInstance.MyRequestServiceCall(loginID: "114177301473189791455")
        // Do any additional setup after loading the view.
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
        requestViewClose.closeRequestID = String(myRequestDetail["RequestID"].int!)
        requestViewClose.modalPresentationStyle = .overCurrentContext
        requestViewClose.modalTransitionStyle = .flipHorizontal
        requestViewClose.view.backgroundColor = UIColor.clear
        self.present(requestViewClose, animated: true, completion: nil)
    }
    //MARK: btnDonorViewTapped
    func btnDonorViewTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        let myRequestDetail = MyRequestArray[buttonRow]
        
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestClose")
        requestView?.modalPresentationStyle = .overCurrentContext
        requestView?.modalTransitionStyle = .flipHorizontal
        requestView?.view.backgroundColor = UIColor.clear
        self.present(requestView!, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if MyRequestArray.count < 1 {
            tableRequestView.isHidden = true
        }
        lblInternetIssue.isHidden = true
        tableRequestView.isHidden = false
        return MyRequestArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:MyRequestCell? = tableRequestView.dequeueReusableCell(withIdentifier: "MyRequestCell") as? MyRequestCell
        if cell == nil
        {
            let nib:Array = Bundle.main.loadNibNamed("MyRequestCell", owner: self, options: nil)!
            cell = nib[0] as? MyRequestCell
        }
        let myRequestDetail = MyRequestArray[indexPath.row]
        
        if myRequestDetail["Status"].string == "Close"
        {
            cell?.viewColorForStatus.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#35ce11")
        }
        else
        {
            cell?.viewColorForStatus.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#ffa800")
        }
        
        cell?.lblPatientName.text = myRequestDetail["PatientName"].string
        cell?.lblBloodGroup.text = myRequestDetail["BloodGroup"].string
        cell?.lblRequestDate.text = Util.SharedInstance.dateChangeForInternal(dateString: myRequestDetail["RequestedOn"].string!)
        
        cell?.btnCloseRequest.tag = indexPath.row
        cell?.btnCloseRequest.addTarget(self, action: #selector(MyRequestView.btnCloseTapped(sender:)), for: .touchUpInside)
        cell?.btnViewDonars.addTarget(self, action: #selector(MyRequestView.btnDonorViewTapped(sender:)), for: .touchUpInside)
        
        return cell!
    }
}
//MARK:- MyRequestProtocol
extension MyRequestView:MyRequestProtocol
{
    func SuccessMyRequest(JSONResponse: JSON)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        var dataArray = JSONResponse["MyRequestsResponse"]["ResponseDetails"]
        if (dataArray.dictionary) != nil
        {
            dataArray = JSON.init(arrayLiteral: dataArray)
        }
        MyRequestArray = dataArray.array!
        self.tableRequestView.reloadData()
    }
    func FailMyRequest()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
    }
}
