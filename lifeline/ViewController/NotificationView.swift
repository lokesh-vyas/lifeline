//
//  NotificationView.swift
//  lifeline
//
//  Created by iSteer on 09/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationView: UIViewController {
    
    @IBOutlet weak var lblTitleText: UILabel!
    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var UserJSON:Dictionary<String, Any> = Dictionary<String, Any>()
    var NotificationList : [Dictionary<String, Any>] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if (UserJSON["Type"] as? String == "1")
        {
            //for welcome notification & Request Status Update
            btnCancel.setTitle("Thanks", for: .normal)
            btnView.isHidden = true
        }
        self.lblTitleText.text = UserJSON["Title"] as? String
        self.lblMessageText.text = UserJSON["Message"] as? String
        
        let storeDataFetch = UserDefaults.standard.object(forKey: "AllNotification")
        if storeDataFetch != nil {
           NotificationList  = storeDataFetch as! [Dictionary<String, Any>]
        }
        
        var tempDict = [String:Any]()
        tempDict["Title"] = UserJSON["Title"] as! String
        tempDict["Message"] = UserJSON["Message"] as! String
        tempDict["Type"] = UserJSON["Type"] as! String
        tempDict["Id"] = UserJSON["ID"] as? String
        tempDict["Status"] = "0"
        tempDict["ExpireDate"] = UserJSON["WhenNeeded"] ?? UserJSON["EndDate"]
        //tempDict["EndDate"] = UserJSON["EndDate"]
        NotificationList.append(tempDict)
        
        UserDefaults.standard.set(NotificationList, forKey: "AllNotification")
        NotificationCenter.default.removeObserver("PushNotificationReloadData")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushNotificationReloadData"), object:nil)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnViewTapped(_ sender: Any)
    {
        print(NotificationList.count)
        NotificationList[NotificationList.count - 1]["Status"] = "1"
        UserDefaults.standard.set(NotificationList, forKey: "AllNotification")
        if (UserJSON["Type"] as? String == "2")
        {
            //After accecpt request
            let myDonorView:MyDonorView = self.storyboard?.instantiateViewController(withIdentifier: "MyDonorView") as! MyDonorView
            myDonorView.MyRequestIDFromPush = UserJSON["ID"] as! String
            let rootView:UINavigationController = UINavigationController.init(rootViewController: myDonorView)
            self.present(rootView, animated: true, completion: nil)
            
        } else if(UserJSON["Type"] as? String == "4" || UserJSON["Type"] as? String == "12") //camp
        {

            //For Camp and Thank you for after confirm camp request
            let confirmDonate:ConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            confirmDonate.ID = UserJSON["ID"] as! String
            let rootView:UINavigationController = UINavigationController(rootViewController: confirmDonate)
            self.present(rootView, animated: true, completion: nil)
            
        } else if(UserJSON["Type"] as? String == "3" || UserJSON["Type"] as? String == "11") //Indi
        {
            
            //for individual request notificaton
            let indconfirmDonate:IndividualConfirmDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
            indconfirmDonate.iID = UserJSON["ID"] as! String
            let rootView:UINavigationController = UINavigationController(rootViewController: indconfirmDonate)
            self.present(rootView, animated: true, completion: nil)
            
        }
    }
}
