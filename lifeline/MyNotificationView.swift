//
//  MyNotificationView.swift
//  lifeline
//
//  Created by Anjali on 31/07/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyNotificationView: UIViewController {
    
    @IBOutlet weak var NotificationTblView: UITableView!
    @IBOutlet weak var NoNewNotifications: UILabel!
    var NotificationList : [Dictionary<String, Any>] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        NotificationTblView.contentInset = UIEdgeInsetsMake(-35, 0.0, 0, 0.0)
        NotificationCenter.default.addObserver(self, selector: #selector(MyNotificationView.PushNotificationViewReloadData), name: NSNotification.Name(rawValue: "PushNotificationReloadData"), object: nil)
    
        NoNewNotifications.isHidden = true
        NotificationTblView.isHidden = true
      
        self.PushNotificationViewReloadData()
        //self.expireeOfNotification()
    }
    //MARK:- ExpireeOfNotification
    /*func expireeOfNotification()
    {
        let dateString: Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = dateFormatter.string(from: dateString)
        let storeDataFetch = UserDefaults.standard.object(forKey: "AllNotification")
        if storeDataFetch != nil {
            NotificationList  = storeDataFetch as! [Dictionary<String, Any>]
        }
        for i in 0..<NotificationList.count {
            let expireeDate = NotificationList[i]["ExpireeDate"]
            let endDate = NotificationList[i]["EndDate"]
            let currentDate1 = dateFormatter.date(from: currentDate)
            if endDate != nil  //camp
            {
                let expireeDateForCamp = Calendar.current.date(byAdding: .day, value: 1, to: endDate as! Date)
                if currentDate1! >= expireeDateForCamp!
                {
                    self.NotificationList.remove(at: i)
                    UserDefaults.standard.set(self.NotificationList, forKey: "AllNotification")
                    self.NotificationTblView.reloadData()
                }
            }
            else if expireeDate != nil  //Indi
            {
                let expireeDateForIndividual = Calendar.current.date(byAdding: .day, value: 2, to: expireeDate as! Date)
                if currentDate1! >= expireeDateForIndividual!
                {
                    self.NotificationList.remove(at: i)
                    UserDefaults.standard.set(self.NotificationList, forKey: "AllNotification")
                    self.NotificationTblView.reloadData()
                }
            }
            else  // Other Notifications
            {
                let expireeDateForOthers = Calendar.current.date(byAdding: .day, value: 3, to: expireeDate as! Date)
                if currentDate1! >= expireeDateForOthers!
                {
                    self.NotificationList.remove(at: i)
                    UserDefaults.standard.set(self.NotificationList, forKey: "AllNotification")
                    self.NotificationTblView.reloadData()
                }
            }
        }
    }*/
    
    //MARK:- PushNotificationView
    func PushNotificationViewReloadData()
    {
        NotificationList.removeAll()
        let storeDataFetch = UserDefaults.standard.object(forKey: "AllNotification")
        if storeDataFetch != nil {
            NotificationList  = storeDataFetch as! [Dictionary<String, Any>]
        }
        self.NotificationTblView.reloadData()
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
            self.NotificationList.remove(at: sender.tag)
            UserDefaults.standard.set(self.NotificationList, forKey: "AllNotification")
            self.NotificationTblView.reloadData() }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {
            _ in
            self.NotificationTblView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(NotificationList.count)
        print(NotificationList[indexPath.row]["Status"] as? String)
        NotificationList[indexPath.row]["Status"] = "1"
        UserDefaults.standard.set(NotificationList, forKey: "AllNotification")

        /*if ((NotificationList[indexPath.row]["Type"] as? String) == "1") {
            NotificationList[indexPath.row]["Status"] = "3"
            let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
            notificationView.UserJSON["Title"] = String(describing: NotificationList[indexPath.row]["Title"])
            notificationView.UserJSON["Message"] = String(describing: NotificationList[indexPath.row]["Message"])
            let rootView:UINavigationController = UINavigationController.init(rootViewController: notificationView)
            self.present(rootView, animated: true, completion: nil)
        }
        else */
        if ((NotificationList[indexPath.row]["Type"] as? String) == "2")
        {
            //After accecpt request
            let myDonorView:MyDonorView = self.storyboard?.instantiateViewController(withIdentifier: "MyDonorView") as! MyDonorView
            myDonorView.MyRequestIDFromPush = String(describing: NotificationList[indexPath.row]["Id"])
            let rootView:UINavigationController = UINavigationController.init(rootViewController: myDonorView)
            self.present(rootView, animated: true, completion: nil)
            
        } else if((NotificationList[indexPath.row]["Type"] as? String) == "4" || (NotificationList[indexPath.row]["Type"] as? String) == "12") //camp
        {
            //For Camp and Thank you for after confirm camp request
            let confirmDonate:ConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            confirmDonate.ID = NotificationList[indexPath.row]["Id"] as! String
            let rootView:UINavigationController = UINavigationController(rootViewController: confirmDonate)
            self.present(rootView, animated: true, completion: nil)
            
        } else if((NotificationList[indexPath.row]["Type"] as? String) == "3" || (NotificationList[indexPath.row]["Type"]as? String) == "11") //Indi
        {
            //for individual request notificaton
            let indconfirmDonate:IndividualConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
            indconfirmDonate.iID = NotificationList[indexPath.row]["Id"] as! String
            let rootView:UINavigationController = UINavigationController(rootViewController: indconfirmDonate)
            self.present(rootView, animated: true, completion: nil)
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if NotificationList.count == 0
        {
            NotificationTblView.isHidden = true
            return 0
        }
        NotificationTblView.isHidden = false
        return NotificationList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        cell?.lblNotificationTitle.text = NotificationList[indexPath.row]["Title"]  as? String
        cell?.lblNotificationDescription.text = NotificationList[indexPath.row]["Message"]  as? String
        
        if((NotificationList[indexPath.row]["Status"] as? String) == "0")
        {
            cell?.PendingImage.image = UIImage(named: "pendingColored")
        }
        else if ((NotificationList[indexPath.row]["Status"] as? String) == "1")
        {
            cell?.PendingImage.image = UIImage(named: "done")
        }
        if ((NotificationList[indexPath.row]["Type"] as? String) == "1") || ((NotificationList[indexPath.row]["Type"] as? String) == "4")
        {
                cell?.PendingImage.image = UIImage(named: "")
        }
        cell?.BtnClose.tag = indexPath.row
        cell?.BtnClose.addTarget(self, action: #selector(MyNotificationView.btnCloseTapped(sender:)), for: .touchUpInside)
        return cell!
    }
    
}
