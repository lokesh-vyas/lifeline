//
//  MyDonorView.swift
//  lifeline
//
//  Created by iSteer on 27/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class MyDonorView: UIViewController {
    @IBOutlet weak var lblInternetIssueMessage: UILabel!
    @IBOutlet weak var btnBackTapped: UIBarButtonItem!
    
    @IBOutlet weak var tableViewDonor: UITableView!
    var MyRequestCloseJSON :JSON = []
    var MyDonorDetailJSON :JSON = []
    var MyStringForCheck = String()
    var MyRequestIDFromPush = String()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MyDonorView.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        self.navigationController?.completelyTransparentBar()
        tableViewDonor.contentInset = UIEdgeInsetsMake(-35, 0.0, -20, 0.0)
        if MyStringForCheck == "MyRequest"
        {
            self.navigationItem.leftBarButtonItem = self.btnBackTapped
            self.FetchDataFromDonorDetail(JSONResponse: MyRequestCloseJSON)
        }
        else
        {
            let LoginID:String
                = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
            self.navigationItem.leftBarButtonItem = nil
            HudBar.sharedInstance.showHudWithMessage(message: "Loading..", view: self.view)
            MyRequestInteractor.SharedInstance.delegate = self
            MyRequestInteractor.SharedInstance.MyRequestServiceCall(loginID: LoginID)
        }
    }
    //MARK:- Share Application URL With Activity
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
    //MARK:- FetchDataFromDonarDetail
    func FetchDataFromDonorDetail(JSONResponse:JSON)
    {
        if (JSONResponse["DonorsDetails"].dictionary != nil)
        {
            var myRequestArray = JSONResponse["DonorsDetails"]["DonorDetails"]
            if (myRequestArray.dictionary) != nil
            {
                myRequestArray = JSON.init(arrayLiteral: myRequestArray)
            }
            MyDonorDetailJSON = myRequestArray
            self.tableViewDonor.reloadData()
        }
        else{
            self.tableViewDonor.isHidden = true
            self.lblInternetIssueMessage.isHidden = false
            self.lblInternetIssueMessage.text = "No one accept your request"
        }
    }
    //MARK:- FetchDataFromDonarDetail
    func FetchRequestIDfromService(JSONResponse:JSON)
    {
        let NotificationRequestID:Int = Int(MyRequestIDFromPush)!
        for (i, _) in JSONResponse.enumerated()
        {
            let requestID:Int = Int(JSONResponse[i]["RequestID"].int!)
            print(requestID)
            print(NotificationRequestID)
            if requestID == NotificationRequestID
            {
                self.FetchDataFromDonorDetail(JSONResponse: JSONResponse[i])
                MyRequestCloseJSON = JSONResponse[i]
                break
            }
        }
    }
    //MARK:- btnBackTapped
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- btnHomeTapped
    @IBAction func btnHomeTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
}
extension MyDonorView:UITableViewDelegate,UITableViewDataSource
{
    //MARK: btnCloseTapped
    func btnEmailTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        let toRecipient = MyDonorDetailJSON[buttonRow]["EmailId"].string
        
        if MFMailComposeViewController.canSendMail()
        {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([toRecipient!])
            mailComposerVC.setSubject("LifeLine - Blood Donation Confirmation")
            mailComposerVC.setMessageBody("https://itunes.apple.com/in/app/lifeline/id1087262408?mt=8", isHTML: false)
            self.present(mailComposerVC, animated: true, completion: nil)
        }
        else{
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    }
    //MARK: btnCloseTapped
    func btnCallTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        let PhoneNumber:String
        if MyDonorDetailJSON[buttonRow]["ContactNumber"].int != nil
        {
            PhoneNumber = String(describing: MyDonorDetailJSON[buttonRow]["ContactNumber"])
        }
        else
        {
            PhoneNumber = MyDonorDetailJSON[buttonRow]["ContactNumber"].string!
        }
        if let url = URL(string: "tel://\(PhoneNumber)") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    func btnCloseTapped(sender:UIButton)
    {
        let buttonRow = sender.tag
        let myDonorDetail = MyDonorDetailJSON[buttonRow]
        let requestViewClose:MyRequestClose = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestClose") as! MyRequestClose
        requestViewClose.MyRequestCloseJSON = MyRequestCloseJSON
        requestViewClose.StringForCheckView = "MyDonor"
        requestViewClose.DonorID = String(describing: myDonorDetail["DonationId"])
        requestViewClose.modalPresentationStyle = .overCurrentContext
        requestViewClose.modalTransitionStyle = .coverVertical
        requestViewClose.view.backgroundColor = UIColor.clear
        self.present(requestViewClose, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MyDonorDetailJSON.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:MyDonorCell? = tableViewDonor.dequeueReusableCell(withIdentifier: "MyDonorCell") as? MyDonorCell
        if cell == nil
        {
            let nib:Array = Bundle.main.loadNibNamed("MyDonorCell", owner: self, options: nil)!
            cell = nib[0] as? MyDonorCell
        }
        cell?.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "ffffff")
        
        let myDonorDetail = MyDonorDetailJSON[indexPath.row]
       
        cell?.lblDonorName.text = myDonorDetail["Name"].string
        if myDonorDetail["ContactNumber"].int != nil
        {
            cell?.lblDonorContactNumber.text = String(describing: myDonorDetail["ContactNumber"])
        }
        else
        {
            cell?.lblDonorContactNumber.text = myDonorDetail["ContactNumber"].string
        }
        cell?.lblDonorEmail.text = myDonorDetail["EmailId"].string
        //MARK: OPEN
        if (MyRequestCloseJSON["Status"].string == "Open")
        {
            if (myDonorDetail["HasDonated"].string == "NULL")
            {
                cell?.viewColorStatus.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#ffa800")
                if myDonorDetail["PreferredDateTime"].dictionary == nil
                {
                    if (myDonorDetail["Comments"].string == "N/A") || (myDonorDetail["Comments"].null == nil)
                    {
                        cell?.lblDonorComment.isHidden = true
                        cell?.imgDonorComment.isHidden = true
                    }
                    else
                    {
                        cell?.lblDonorComment.isHidden = false
                        cell?.imgDonorComment.isHidden = false
                        cell?.lblDonorComment.text = myDonorDetail["Comments"].string
                    }
                    cell?.lblDonorTime.text = Util.SharedInstance.dateChangeForInternal(dateString: myDonorDetail["PreferredDateTime"].string!)
                    cell?.btnCloseTapped.tag = indexPath.row
                    cell?.btnCloseTapped.addTarget(self, action: #selector(MyDonorView.btnCloseTapped(sender:)), for: .touchUpInside)
                }
            }
            else
            {
                cell?.viewColorStatus.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#35ce11")
                cell?.btnCloseTapped.isHidden = true
                cell?.imgCloseView.isHidden = true
                if myDonorDetail["PreferredDateTime"].string != nil
                {
                    cell?.lblDonorComment.text = myDonorDetail["HasDonated"].string
                    cell?.lblDonorTime.text = Util.SharedInstance.dateChangeForInternal(dateString: myDonorDetail["PreferredDateTime"].string!)
                }
            }
            
        }
            //MARK: ClOSE
        else if(MyRequestCloseJSON["Status"].string == "Close")
        {
            cell?.viewColorStatus.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#35ce11")
            cell?.btnCloseTapped.isHidden = true
            cell?.imgCloseView.isHidden = true
            if (myDonorDetail["HasDonated"] == "NULL")
            {
                if myDonorDetail["PreferredDateTime"].dictionary == nil
                {
                    if (myDonorDetail["Comments"].string == "N/A") || (myDonorDetail["Comments"].null == nil)
                    {
                        cell?.lblDonorComment.isHidden = true
                        cell?.imgDonorComment.isHidden = true
                    }
                    else
                    {
                        cell?.lblDonorComment.isHidden = false
                        cell?.imgDonorComment.isHidden = false
                        cell?.lblDonorComment.text = myDonorDetail["Comments"].string
                    }
                    cell?.lblDonorTime.text = Util.SharedInstance.dateChangeForInternal(dateString: myDonorDetail["PreferredDateTime"].string!)
                }
            }
            else if(myDonorDetail["HasDonated"] == "NO")
            {
                if myDonorDetail["PreferredDateTime"].string == nil
                {
                    
                    cell?.lblDonorComment.isHidden = true
                    cell?.imgDonorComment.isHidden = true
                    cell?.lblDonorTime.text = Util.SharedInstance.dateChangeForInternal(dateString: myDonorDetail["PreferredDateTime"].string!)
                }
            }
            else if(myDonorDetail["HasDonated"] == "YES")
            {
                if myDonorDetail["PreferredDateTime"].string == nil
                {
                    
                    cell?.lblDonorComment.isHidden = true
                    cell?.imgDonorComment.isHidden = true
                    cell?.lblDonorTime.text = Util.SharedInstance.dateChangeForInternal(dateString: myDonorDetail["PreferredDateTime"].string!)
                }
            }
        }
        cell?.btnCallTapped.tag = indexPath.row
        cell?.btnCallTapped.addTarget(self, action: #selector(MyDonorView.btnCallTapped(sender:)), for: .touchUpInside)
        cell?.btnEmailTapped.tag = indexPath.row
        cell?.btnEmailTapped.addTarget(self, action: #selector(MyDonorView.btnEmailTapped(sender:)), for: .touchUpInside)
        
        return cell!
    }
}
//MARK:- MyRequestProtocol
extension MyDonorView:MyRequestProtocol
{
    func SuccessMyRequest(JSONResponse: JSON, Sucess: Bool)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        var dataArray = JSONResponse["MyRequestsResponse"]["ResponseDetails"]
        if (dataArray.dictionary) != nil
        {
            dataArray = JSON.init(arrayLiteral: dataArray)
        }
        self.FetchRequestIDfromService(JSONResponse: dataArray)
    }
    func FailMyRequest(Response:String)
    {
        self.tableViewDonor.isHidden = true
        self.lblInternetIssueMessage.isHidden = false
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.lblInternetIssueMessage.text = "No Internet Connection, please check your Internet Connection"
        }else
        {
            self.lblInternetIssueMessage.text = "Unable to access server, please try again later"
        }
    }
}
extension MyDonorView : MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate
{
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch (result)
        {
        case MFMailComposeResult.cancelled:
            self.view.makeToast("LifeLine mail cancelled", duration: 2.0, position: .bottom)
            break;
        case MFMailComposeResult.saved:
            self.view.makeToast("LifeLine mail saved message in the drafts folder", duration: 2.0, position: .bottom)
            break;
        case MFMailComposeResult.sent:
            self.view.makeToast("LifeLine mail sent successfully", duration: 2.0, position: .bottom)
            break;
        case MFMailComposeResult.failed:
              self.view.makeToast("LifeLine mail failed", duration: 2.0, position: .bottom)
            break;
            }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

