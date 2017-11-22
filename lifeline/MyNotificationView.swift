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
    var notificationId: Int?
    var loader : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        NotificationTblView.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        NoNewNotifications.isHidden = true
        NotificationTblView.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        MyNotificationViewModel.SharedInstance.delegate = self
        MyNotificationViewModel.SharedInstance.NotificationList.removeAll()
        MyNotificationViewModel.SharedInstance.MyNotificationServerCall()
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    @IBAction func BtnBackTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    
    //MARK:- PushNotificationView
    func PushNotificationView(_ notification: NSNotification)
    {
        let dict = notification.object as! Dictionary<String, Any>
        
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .currentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
    }
}
extension MyNotificationView : UITableViewDelegate, UITableViewDataSource
{
     func btnCloseTapped(sender:UIButton)
     {
        let alert: UIAlertController = UIAlertController(title: MultiLanguage.getLanguageUsingKey("DELETE_TITLE"), message: MultiLanguage.getLanguageUsingKey("DELETE_MESSAGE"), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_YES"), style: UIAlertActionStyle.default, handler: {
             _ in
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificationDelete(NotificationId: self.notificationId!)
            MyNotificationViewModel.SharedInstance.NotificationList.remove(at: sender.tag)
           }))
        
        alert.addAction(UIAlertAction(title: MultiLanguage.getLanguageUsingKey("BTN_NO"), style: UIAlertActionStyle.default, handler: {
            _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if MyNotificationViewModel.SharedInstance.NotificationList.count < 1 {
            NotificationTblView.isHidden = true
            NoNewNotifications.isHidden = false
            NoNewNotifications.text = MultiLanguage.getLanguageUsingKey("NO_NOTIFICATIONS")
        }
        NoNewNotifications.isHidden = true
        NotificationTblView.isHidden = false
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
        self.notificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
        cell?.BtnClose.tag = indexPath.row
        cell?.BtnClose.addTarget(self, action: #selector(MyNotificationView.btnCloseTapped(sender:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == 1)
        {
            //Welcome Notification
            let myNotificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificatonUpdate(NotificationId: myNotificationId!)
            let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
            notificationView.UserJSON["Type"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType
            notificationView.UserJSON["Title"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Title
            notificationView.UserJSON["Message"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Message
            notificationView.modalPresentationStyle = .overCurrentContext
            notificationView.modalTransitionStyle = .coverVertical
            notificationView.view.backgroundColor = UIColor.clear
            self.present(notificationView, animated: true, completion: nil)
        } else if (MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == 2)
        {
            //After accecpt request
            let myNotificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificatonUpdate(NotificationId: myNotificationId!)
            let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
            notificationView.UserJSON["Type"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType
            notificationView.UserJSON["Title"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Title
            notificationView.UserJSON["Message"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Message
            notificationView.UserJSON["ID"] = String(describing: MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].RequestID!)
            notificationView.modalPresentationStyle = .overCurrentContext
            notificationView.modalTransitionStyle = .coverVertical
            notificationView.view.backgroundColor = UIColor.clear
            self.present(notificationView, animated: true, completion: nil)
        } else if (MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == 5)
        {
            //Thank you Notification
            let myNotificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificatonUpdate(NotificationId: myNotificationId!)
            let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
            notificationView.UserJSON["Type"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType
            notificationView.UserJSON["Title"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Title
            notificationView.UserJSON["Message"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Message
            notificationView.modalPresentationStyle = .overCurrentContext
            notificationView.modalTransitionStyle = .coverVertical
            notificationView.view.backgroundColor = UIColor.clear
            self.present(notificationView, animated: true, completion: nil)
        } else if(MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == 4) //camp
        {
            //For Camp Request Notification
            let myNotificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificatonUpdate(NotificationId: myNotificationId!)
            let confirmDonate:ConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            confirmDonate.ID = String(describing: MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].CampaignID!)
            let rootView:UINavigationController = UINavigationController(rootViewController: confirmDonate)
            self.present(rootView, animated: true, completion: nil)
            
        } else if(MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == 3) //Indi
        {
            //for individual request notificaton
            let myNotificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificatonUpdate(NotificationId: myNotificationId!)
            let indconfirmDonate:IndividualConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
            indconfirmDonate.iID = String(describing: MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].RequestID!)
            let rootView:UINavigationController = UINavigationController(rootViewController: indconfirmDonate)
            self.present(rootView, animated: true, completion: nil)
        } else if(MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType == 6)
        {
            // Thank you for volunteering Notification
            let myNotificationId = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationId
            MyNotificationViewModel.SharedInstance.delegate = self
            MyNotificationViewModel.SharedInstance.MyNotificatonUpdate(NotificationId: myNotificationId!)
            let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
            notificationView.UserJSON["Type"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].NotificationType
            notificationView.UserJSON["Title"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Title
            notificationView.UserJSON["Message"] = MyNotificationViewModel.SharedInstance.NotificationList[indexPath.row].Message
            notificationView.modalPresentationStyle = .overCurrentContext
            notificationView.modalTransitionStyle = .coverVertical
            notificationView.view.backgroundColor = UIColor.clear
            self.present(notificationView, animated: true, completion: nil)
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
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if MyNotificationViewModel.SharedInstance.NotificationList.count <= 0
        {
            self.NotificationTblView.isHidden = true
            self.NoNewNotifications.isHidden = false
            NoNewNotifications.text = MultiLanguage.getLanguageUsingKey("NO_NOTIFICATIONS")
        }
        else
        {
            self.NotificationTblView.isHidden = false
            self.NoNewNotifications.isHidden = true
            self.NotificationTblView.reloadData()
        }
    }
    func didFail(){
         HudBar.sharedInstance.hideHudFormView(view: self.view)
         self.NotificationTblView.isHidden = true
         self.NoNewNotifications.isHidden = false
         NoNewNotifications.text = MultiLanguage.getLanguageUsingKey("NO_NOTIFICATIONS")
    }
}
