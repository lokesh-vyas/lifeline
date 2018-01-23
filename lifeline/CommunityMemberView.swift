//
//  CommunityMemberView.swift
//  lifeline
//
//  Created by Anjali on 08/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit

class CommunityMemberView: UIViewController {
    
    @IBOutlet weak var tblViewMember: UITableView!
    @IBOutlet weak var lblNoMember: UILabel!
    var CommunityMemberJSON:Dictionary<String, Any> = Dictionary<String, Any>()
    
    var myCLoginid = String()
    var myCommunityId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblViewMember.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        tblViewMember.isHidden = true
        lblNoMember.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        let myCommunityId = CommunityMemberJSON["CommunityId"]
        getCommunityViewModel.SharedInstance.delegate = self as? getCommunityProtocol
        getCommunityViewModel.SharedInstance.getCommunityList.removeAll()
        getCommunityViewModel.SharedInstance.getCommunityMember(communityId: myCommunityId as! Int)
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
    func btnRemoveTapped(sender : UIButton) {
        print("Successfully Removed")
        sender.isHidden = true
        UpdateCommunityMemberModel.SharedInstance.delegate = self as? updateCommunityMemberProtocol
        UpdateCommunityMemberModel.SharedInstance.UpdateCommunityMember(loginId: self.myCLoginid, communityId: self.myCommunityId, isActive: 0)
        getCommunityViewModel.SharedInstance.getCommunityList.remove(at: sender.tag)
    }
}
extension CommunityMemberView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getCommunityViewModel.SharedInstance.getCommunityList.count < 1 {
            tblViewMember.isHidden = true
            lblNoMember.isHidden = false
            lblNoMember.text = "No Members Added in your community."
        }
        tblViewMember.isHidden = false
        lblNoMember.isHidden = true
        return getCommunityViewModel.SharedInstance.getCommunityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "MemberCommunityCell"
        var cell:MemberCommunityCell? = tblViewMember.dequeueReusableCell(withIdentifier: cellIdentifier) as? MemberCommunityCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("MemberCommunityCell", owner: self, options: nil)!
            cell = nib[0] as? MemberCommunityCell
            print("cell = \(String(describing: cell))")
        }
        cell?.viewBackGround.completelyTransparentView()
        cell?.lblName.text = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Name
        self.myCLoginid = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].LoginId!
        self.myCommunityId = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].CommunityId!
        cell?.constraintForHorizontalSpace.constant = 8
        cell?.btnAccept.isHidden = true
        cell?.btnReject.setTitle("Remove", for: .normal)
        cell?.btnReject.tag = indexPath.row
        cell?.btnReject.addTarget(self, action: #selector(CommunityMemberView.btnRemoveTapped(sender:)), for: .touchUpInside)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
extension CommunityMemberView: getCommunityProtocol {
    func didSucess(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0 {
            self.tblViewMember.isHidden = true
            self.lblNoMember.isHidden = false
            lblNoMember.text = "No Members Added in your community."
        }
        else {
            self.tblViewMember.isHidden = false
            self.tblViewMember.reloadData()
            self.lblNoMember.isHidden = true
        }
    }
    func didFail(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.tblViewMember.isHidden = true
        self.lblNoMember.isHidden = false
        lblNoMember.text = "No Members Added in your community."
    }
}
extension CommunityMemberView: updateCommunityMemberProtocol {
    func didSuccess(StatusCode: Int) {
        if StatusCode == 0 {
            self.view.makeToast("Requested Details Updated Successfully.", duration: 3.0, position: .bottom)
            if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0 {
                self.tblViewMember.isHidden = true
                self.lblNoMember.isHidden = false
                lblNoMember.text = "No Members Added in your community."
            }
            else {
                self.tblViewMember.isHidden = false
                self.tblViewMember.reloadData()
                self.lblNoMember.isHidden = true
            }
        }else if StatusCode == 1 {
            self.view.makeToast("There is no member on this Community.", duration: 3.0, position: .bottom)
        }
    }
    func didFail(Response: String) {
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
