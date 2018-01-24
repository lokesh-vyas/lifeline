//
//  MyCommunityView.swift
//  lifeline
//
//  Created by Anjali on 29/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCommunityView: UIViewController {
    
    @IBOutlet weak var lblNoCommunity: UILabel!
    @IBOutlet weak var tblCommunity: UITableView!
    var name = String()           // Not using
    var communityId = Int()       // Local varible
    var phone = String()          //not using
    var cLoginId = String()       // local Varible
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblCommunity.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        lblNoCommunity.isHidden = true
        tblCommunity.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        getCommunityViewModel.SharedInstance.delegate = self
        getCommunityViewModel.SharedInstance.getCommunityList.removeAll()
        getCommunityViewModel.SharedInstance.getMyCommunityServerCall()
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    func reloadData() {
        self.tblCommunity.reloadData()
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    @IBAction func btnExploreTapped(_ sender: Any) {
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "AllCommunitiesView")
        let nav = UINavigationController(rootViewController: storyObj!)
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func btnCreateCommunityTapped(_ sender: Any) {
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateCommunityView")
        let nav = UINavigationController(rootViewController: storyObj!)
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func btnInvitesTapped(_ sender: Any) {
        SingleTon.SharedInstance.cameFromMyCommunity = true
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "InviteView")
        let nav = UINavigationController(rootViewController: storyObj!)
        self.present(nav, animated: true, completion: nil)
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
    func btnLeaveTapped(sender : UIButton) {
        print("Successfully Left")
        self.communityId = getCommunityViewModel.SharedInstance.getCommunityList[sender.tag].CommunityId!
        self.cLoginId = String(describing: getCommunityViewModel.SharedInstance.getCommunityList[sender.tag].LoginId!)
        UpdateCommunityMemberModel.SharedInstance.delegate = self 
        UpdateCommunityMemberModel.SharedInstance.UpdateCommunityMember(loginId: self.cLoginId, communityId: self.communityId, isActive: 0)
        //getCommunityViewModel.SharedInstance.getCommunityList.remove(at: sender.tag)s
    }
}

//MARK:- TabelView Delegate
extension MyCommunityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getCommunityViewModel.SharedInstance.getCommunityList.count < 1 {
            tblCommunity.isHidden = true
            lblNoCommunity.isHidden = false
            lblNoCommunity.text = "You are not member of any community."
        }
        lblNoCommunity.isHidden = true
        tblCommunity.isHidden = false
        return getCommunityViewModel.SharedInstance.getCommunityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "myCommunityCell"
        var cell:myCommunityCell? = tblCommunity.dequeueReusableCell(withIdentifier: cellIdentifier) as? myCommunityCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("myCommunityCell", owner: self, options: nil)!
            cell = nib[0] as? myCommunityCell
            print("cell = \(String(describing: cell))")
        }
        cell?.btnFollow.setTitle("Leave", for: .normal)
        //MARK:- Leave Community
        cell?.btnFollow.tag = indexPath.row
        cell?.btnFollow.addTarget(self, action: #selector(btnLeaveTapped(sender:)), for: .touchUpInside)
        cell?.communityBackgroundView.completelyTransparentView()
        cell?.lblGroupTitle.text = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Name
        cell?.lblGroupDescription.text = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Description
        if let a = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].type {
            cell?.lblClosedGroup.text = "\(a) Group"
            if a == "Closed" {
                cell?.imgClosed.image = UIImage(named: "locked-padlock")
            }else {
                cell?.imgClosed.image = UIImage(named: "unlocked")
            }
        }
        if getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].isBloodbank == false {
            cell?.lblBloodBank.isHidden = true
            cell?.imgDropBlack.isHidden = true
        }
        else {
            cell?.lblBloodBank.isHidden = false
            cell?.imgDropBlack.isHidden = false
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let communityView:CommunityDetailView = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailView") as! CommunityDetailView
         communityView.CommunityJSON["Name"] = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Name
         communityView.CommunityJSON["Description"] = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Description
        communityView.CommunityJSON["Type"] = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].type
        let communityContact =  String(describing: getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].phone)
        if communityContact == "null"
        {
            communityView.CommunityJSON["ContactNumber"] = "00"
        }else
        {
            communityView.CommunityJSON["ContactNumber"] = communityContact
        }
        communityView.CommunityJSON["ContactName"] = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].ContactPerson
        communityView.CommunityJSON["CommunityId"] = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].CommunityId
        communityView.CommunityJSON["LoginId"] = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].LoginId
        let rootView:UINavigationController = UINavigationController(rootViewController: communityView)
        self.present(rootView, animated: true, completion: nil)
    }
}

extension MyCommunityView : getCommunityProtocol{
    func didSucess(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0
        {
            self.tblCommunity.isHidden = true
            self.lblNoCommunity.isHidden = false
            self.lblNoCommunity.text = "You are not member of any community"
        }
        else
        {
            self.tblCommunity.isHidden = false
            self.lblNoCommunity.isHidden = true
            self.tblCommunity.reloadData()
        }
    }
    func didFail(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.tblCommunity.isHidden = true
        self.lblNoCommunity.isHidden = false
        self.lblNoCommunity.text = "You are not member of any community."
    }
}
extension MyCommunityView: updateCommunityMemberProtocol {
    func didSuccess(StatusCode: Int) {
        if StatusCode == 0 {
            self.view.makeToast("Requested Details Updated Successfully.", duration: 3.0, position: .bottom)
            if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0
            {
                self.tblCommunity.isHidden = true
                self.lblNoCommunity.isHidden = false
                self.lblNoCommunity.text = "You are not member of any community."
            }
            else
            {
                self.tblCommunity.isHidden = false
                self.lblNoCommunity.isHidden = true
                self.tblCommunity.reloadData()
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
