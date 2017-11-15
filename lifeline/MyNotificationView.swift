//
//  MyNotificationView.swift
//  lifeline
//
//  Created by Anjali on 31/07/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyNotificationView: UIViewController {
    
    @IBOutlet weak var NotificationTblView: UITableView!
    @IBOutlet weak var NoNewNotifications: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing")
        self.navigationController?.completelyTransparentBar()
        NotificationTblView.contentInset = UIEdgeInsetsMake(-35, 0.0, 0, 0.0)
        NoNewNotifications.isHidden = true
        NotificationTblView.isHidden = true
        MyNotificationViewModel.SharedInstance.delegate = self
        MyNotificationViewModel.SharedInstance.MyNotificationServerCall()
    }
    @IBAction func BtnBackTapped(_ sender: Any) {
        
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
}

extension MyNotificationView : UITableViewDelegate, UITableViewDataSource
{
     func btnCloseTapped(sender:UIButton)
     {
        let alert: UIAlertController = UIAlertController(title: "Delete Notification", message: "Are you sure you want to delete this notification", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {
             _ in
            MyNotificationViewModel.SharedInstance.NotificationList.remove(at: sender.tag)
            //FIXME:- Service Call For Delete with ID
           // MyNotificationViewModel.SharedInstance.delegate = self
            //MyNotificationViewModel.SharedInstance.MyNotificationDelete(NotificationId: "")
           }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {
            _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MyNotificationViewModel.SharedInstance.NotificationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "NotificationCell"
        var cell:NotificationCell? = NotificationTblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NotificationCell
        
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("NotificationCell", owner: self, options: nil)!
            cell = nib[0] as? NotificationCell
            print("cell = \(String(describing: cell))")
        }
        cell?.NotificationListData = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row]
        cell?.BtnClose.tag = indexPath.row
        cell?.BtnClose.addTarget(self, action: #selector(MyNotificationView.btnCloseTapped(sender:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == "2")
        {
            //After accecpt request
            //FIXME:- Call Update Service Here
            let myDonorView:MyDonorView = self.storyboard?.instantiateViewController(withIdentifier: "MyDonorView") as! MyDonorView
            myDonorView.MyRequestIDFromPush = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].DonationID!
            let rootView:UINavigationController = UINavigationController.init(rootViewController: myDonorView)
            self.present(rootView, animated: true, completion: nil)
            
            
        } else if(MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == "4" || MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == "12") //camp
        {
            //For Camp and Thank you for after confirm camp request
            //FIXME:- Call Update Service Here
            let confirmDonate:ConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            confirmDonate.ID = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].DonationID!
            let rootView:UINavigationController = UINavigationController(rootViewController: confirmDonate)
            self.present(rootView, animated: true, completion: nil)
            
        } else if(MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == "3" || MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == "11") //Indi
        {
            //for individual request notificaton
            //FIXME:- Call Update Service Here
            let indconfirmDonate:IndividualConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
            indconfirmDonate.iID = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].DonationID!
            let rootView:UINavigationController = UINavigationController(rootViewController: indconfirmDonate)
            self.present(rootView, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
extension MyNotificationView : NotificationUpdateProtocol{
    func didSucess(){
        self.NotificationTblView.reloadData()
    }
    func didFail(){
         self.NotificationTblView.reloadData()
        // Show Message for Failure
    }
}
