//
//  AdminInviteView.swift
//  lifeline
//
//  Created by Anjali on 12/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit

class AdminInviteView: UIViewController {
    //
    @IBOutlet weak var tblViewInvite: UITableView!
    @IBOutlet weak var lblNoInvites: UILabel!
    var inviteId = Int()
    var AdminInviteJSON:Dictionary<String, Any> = Dictionary<String, Any>()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblViewInvite.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        tblViewInvite.isHidden = true
        lblNoInvites.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        let myCommunityId = AdminInviteJSON["CommunityId"]
        getCommunityViewModel.SharedInstance.delegate = self as! getCommunityProtocol
        getCommunityViewModel.SharedInstance.getCommunityList.removeAll()
        getCommunityViewModel.SharedInstance.GetAllInvitations(communityId: myCommunityId as! Int)
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
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCreateInviteTapped(_ sender: Any) {
        let inviteView:CreateInviteView = self.storyboard?.instantiateViewController(withIdentifier: "CreateInviteView") as! CreateInviteView
        inviteView.memberInvite["CommunityId"] = AdminInviteJSON["CommunityId"]
        let rootView:UINavigationController = UINavigationController(rootViewController: inviteView)
        self.present(rootView, animated: true, completion: nil)
    }
    func btnCancelTapped(sender: UIButton){
        let buttonRow = sender.tag
        let inviteStatus = getCommunityViewModel.SharedInstance.getCommunityList[buttonRow].inviteStatus
        if inviteStatus == "Pending" {
            sender.setTitle("Cancelled", for: .normal)
            UpdateCommunityMemberModel.SharedInstance.delegate = self as? updateCommunityMemberProtocol
            UpdateCommunityMemberModel.SharedInstance.UpdateInvite(inviteId: self.inviteId, inviteStatus: "Rejected")
            getCommunityViewModel.SharedInstance.getCommunityList.remove(at: sender.tag)
        }else {
            self.view.makeToast("You Cannot Cancel this Invitation", duration: 3.0, position: .bottom)
        }
    }
}
extension AdminInviteView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getCommunityViewModel.SharedInstance.getCommunityList.count < 1 {
            tblViewInvite.isHidden = true
            lblNoInvites.isHidden = false
            lblNoInvites.text = "Currently No Invites available"
        }
        tblViewInvite.isHidden = false
        lblNoInvites.isHidden = true
        return getCommunityViewModel.SharedInstance.getCommunityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "AdminInviteCell"
        var cell:AdminInviteCell? = tblViewInvite.dequeueReusableCell(withIdentifier: cellIdentifier) as? AdminInviteCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("AdminInviteCell", owner: self, options: nil)!
            cell = nib[0] as? AdminInviteCell
            print("cell = \(String(describing: cell))")
        }
        cell?.viewBackground.completelyTransparentView()
        cell?.lblName.text = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].userName!
        cell?.lblStatus.text = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].inviteStatus
        cell?.lblEmail.text = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].emailID!
        self.inviteId = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].inviteId!
        cell?.btnCancelInvite.tag = indexPath.row
        cell?.btnCancelInvite.addTarget(self, action: #selector(AdminInviteView.btnCancelTapped(sender:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension AdminInviteView : getCommunityProtocol{
    func didSucess(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0 {
            self.tblViewInvite.isHidden = true
            self.lblNoInvites.isHidden = false
            self.lblNoInvites.text = "Currently No Invites available"
        }
        else {
            self.lblNoInvites.isHidden = true
            self.tblViewInvite.isHidden = false
            self.tblViewInvite.reloadData()
        }
    }
    func didFail(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.tblViewInvite.isHidden = true
        self.lblNoInvites.isHidden = false
        self.lblNoInvites.text = "Currently No Invites available"
    }
}
extension AdminInviteView: updateCommunityMemberProtocol {
    func didFail(Response: String) {
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
    func didSuccess(StatusCode: Int) {
        if StatusCode == 0 {
            self.view.makeToast("Requested Details Updated Successfully.", duration: 3.0, position: .bottom)
            if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0
            {
                self.tblViewInvite.isHidden = true
                self.lblNoInvites.isHidden = false
                self.lblNoInvites.text = "Currently No Invites available"
            }
            else
            {
                self.lblNoInvites.isHidden = true
                self.tblViewInvite.isHidden = false
                self.tblViewInvite.reloadData()
            }
        }else if StatusCode == 1 {
            self.view.makeToast("Something Went Wrong", duration: 3.0, position: .bottom)
        }
    }
}

