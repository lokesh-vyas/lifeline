//
//  InviteView.swift
//  lifeline
//
//  Created by Anjali on 30/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class InviteView: UIViewController {
    //MARK:- View Outlet
    @IBOutlet weak var lblNoInvites: UILabel!
    @IBOutlet weak var inviteTblView: UITableView!
    //MARK:- Variable
    fileprivate var inviteId = Int()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        inviteTblView.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        lblNoInvites.isHidden = true
        inviteTblView.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        getCommunityViewModel.SharedInstance.delegate = self
        getCommunityViewModel.SharedInstance.getCommunityList.removeAll()
        getCommunityViewModel.SharedInstance.GetUsersInvitations()
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
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
    func btnRejectTapped(sender: UIButton){
       sender.setTitle("Rejected", for: .normal)
       UpdateCommunityMemberModel.SharedInstance.delegate = self
       UpdateCommunityMemberModel.SharedInstance.UpdateInvite(inviteId: self.inviteId, inviteStatus: "Rejected")
       getCommunityViewModel.SharedInstance.getCommunityList.remove(at: sender.tag)
    }
    func btnAcceptTapped(sender: UIButton){
        sender.setTitle("Accepted", for: .normal)
        UpdateCommunityMemberModel.SharedInstance.delegate = self
        UpdateCommunityMemberModel.SharedInstance.UpdateInvite(inviteId: self.inviteId, inviteStatus: "Accepted")
        getCommunityViewModel.SharedInstance.getCommunityList.remove(at: sender.tag)
    }
}
extension InviteView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getCommunityViewModel.SharedInstance.getCommunityList.count < 1 {
            inviteTblView.isHidden = true
            lblNoInvites.isHidden = false
            lblNoInvites.text = "Currently No Invites available"
        }
        inviteTblView.isHidden = false
        lblNoInvites.isHidden = true
        return getCommunityViewModel.SharedInstance.getCommunityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "MemberCommunityCell"
        var cell:MemberCommunityCell? = inviteTblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MemberCommunityCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("MemberCommunityCell", owner: self, options: nil)!
            cell = nib[0] as? MemberCommunityCell
            print("cell = \(String(describing: cell))")
        }
        cell?.viewBackGround.completelyTransparentView()
        cell?.lblName.text = String(describing:getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Name!)
        self.inviteId = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].inviteId!
        cell?.btnReject.tag = indexPath.row
        cell?.btnReject.addTarget(self, action: #selector(InviteView.btnRejectTapped(sender:)), for: .touchUpInside)
        cell?.btnAccept.tag = indexPath.row
        cell?.btnAccept.addTarget(self, action: #selector(InviteView.btnAcceptTapped(sender:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension InviteView : getCommunityProtocol{
    func didSucess(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0 {
            self.inviteTblView.isHidden = true
            self.lblNoInvites.isHidden = false
            self.lblNoInvites.text = "Currently No Invites available"
        }
        else {
            self.lblNoInvites.isHidden = true
            self.inviteTblView.isHidden = false
            self.inviteTblView.reloadData()
        }
    }
    func didFail(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.inviteTblView.isHidden = true
        self.lblNoInvites.isHidden = false
        self.lblNoInvites.text = "Currently No Invites available"
    }
}
extension InviteView: updateCommunityMemberProtocol {
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
                self.inviteTblView.isHidden = true
                self.lblNoInvites.isHidden = false
                self.lblNoInvites.text = "Currently No Invites available"
            }
            else
            {
                self.lblNoInvites.isHidden = true
                self.inviteTblView.isHidden = false
                self.inviteTblView.reloadData()
            }
        }else if StatusCode == 1 {
            self.view.makeToast("Something Went Wrong", duration: 3.0, position: .bottom)
        }
    }
}
