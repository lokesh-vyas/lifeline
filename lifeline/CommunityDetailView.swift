//
//  CommunityDetailView.swift
//  lifeline
//
//  Created by Anjali on 08/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit

class CommunityDetailView: UIViewController {
    
    //@IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblGroupType: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMember: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnInvite: UIButton!
    var CommunityJSON:Dictionary<String, Any> = Dictionary<String, Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        //imgProfilePic.setRounded()
        lblName.text = CommunityJSON["Name"] as? String
        lblDescription.text = CommunityJSON["Description"] as? String
        if let a = CommunityJSON["Type"] {
          lblGroupType.text = ("\(String(describing: a)) Group")
        }
        
        let myLoginId: String = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
        let cLoginId: String = CommunityJSON["LoginId"]! as! String
        if myLoginId == cLoginId {
            self.btnEdit.isHidden = false
            self.btnMember.isHidden = false
            self.btnInvite.isHidden = false
        }else {
            self.btnEdit.isHidden = true
            self.btnMember.isHidden = true
            self.btnInvite.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    //MARK:- PushNotificationView
    func PushNotificationView(_ notification: NSNotification) {
        let dict = notification.object as! Dictionary<String, Any>
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .currentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        if SingleTon.SharedInstance.cameFromMyCommunity == true {
            let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "MyCommunityView")
            let nav = UINavigationController(rootViewController: storyObj!)
            self.present(nav, animated: true, completion: nil)
        }else {
            let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "AllCommunitiesView")
            let nav = UINavigationController(rootViewController: storyObj!)
            self.present(nav, animated: true, completion: nil)
        }
    }
    @IBAction func btnEditTapped(_ sender: Any) {
        let updateView:UpdateCommunityView = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCommunityView") as! UpdateCommunityView
        updateView.updateCommunityJSON["Name"] = CommunityJSON["Name"] as? String
        updateView.updateCommunityJSON["Description"] = CommunityJSON["Description"] as? String
        updateView.updateCommunityJSON["Type"] = CommunityJSON["Type"] as? String
        updateView.updateCommunityJSON["ContactNumber"] = CommunityJSON["ContactNumber"]!
        updateView.updateCommunityJSON["ContactName"] = CommunityJSON["ContactName"]
        updateView.updateCommunityJSON["CommunityId"] = CommunityJSON["CommunityId"]
        let rootView:UINavigationController = UINavigationController(rootViewController: updateView)
        self.present(rootView, animated: true, completion: nil)
    }
    @IBAction func btnMemberListTapped(_ sender: Any) {
        let memberView:CommunityMemberView = self.storyboard?.instantiateViewController(withIdentifier: "CommunityMemberView") as! CommunityMemberView
        memberView.CommunityMemberJSON["CommunityId"] = CommunityJSON["CommunityId"] 
        let rootView:UINavigationController = UINavigationController(rootViewController: memberView)
        self.present(rootView, animated: true, completion: nil)
    }
    @IBAction func btnIviteListTapped(_ sender: Any) {
        let inviteView:AdminInviteView = self.storyboard?.instantiateViewController(withIdentifier: "AdminInviteView") as! AdminInviteView
        inviteView.AdminInviteJSON["CommunityId"] = CommunityJSON["CommunityId"]
        let rootView:UINavigationController = UINavigationController(rootViewController: inviteView)
        self.present(rootView, animated: true, completion: nil)
    }
}
