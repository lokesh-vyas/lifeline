//
//  AllCommunitiesView.swift
//  lifeline
//
//  Created by Anjali on 28/12/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllCommunitiesView: UIViewController {
    @IBOutlet weak var tblAllCommunity: UITableView!
    @IBOutlet weak var lblNoCommunity: UILabel!
    var name = String()
    var communityId = Int()
    var phone = String()
    var loginId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblAllCommunity.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        tblAllCommunity.isHidden = true
        lblNoCommunity.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        getCommunityViewModel.SharedInstance.delegate = self 
        getCommunityViewModel.SharedInstance.getCommunityList.removeAll()
        getCommunityViewModel.SharedInstance.getAllCommunityServerCall()
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    func reloadData() {
        self.tblAllCommunity.reloadData()
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "MyCommunityView")
        let nav = UINavigationController(rootViewController: storyObj!)
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func btnCreateCommunityTapped(_ sender: Any) {
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "CreateCommunityView")
        let nav = UINavigationController(rootViewController: storyObj!)
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func btnInvitesTapped(_ sender: Any) {
        SingleTon.SharedInstance.cameFromMyCommunity = false
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
    func btnJoinTapped(sender : UIButton) {
        print("Successfully Joined")
        sender.setTitle("Following", for: .normal)
        RequestCommunityViewModel.SharedInstance.delegate = self as? requestCommunityProtocol
        RequestCommunityViewModel.SharedInstance.RequestCommunity(name: name, communityId: communityId, loginId: self.loginId)
    }
}
extension AllCommunitiesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if getCommunityViewModel.SharedInstance.getCommunityList.count < 1 {
            self.tblAllCommunity.isHidden = true
            self.lblNoCommunity.isHidden = false
            self.lblNoCommunity.text = "Currently No Community Available."
        }
        self.tblAllCommunity.isHidden = false
        self.lblNoCommunity.isHidden = true
        return getCommunityViewModel.SharedInstance.getCommunityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier:String = "myCommunityCell"
        var cell:myCommunityCell? = tblAllCommunity.dequeueReusableCell(withIdentifier: cellIdentifier) as? myCommunityCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("myCommunityCell", owner: self, options: nil)!
            cell = nib[0] as? myCommunityCell
            print("cell = \(String(describing: cell))")
        }
        //MARK:- JOIN COMMUNITY
        self.communityId = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].CommunityId!
        self.name = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].Name!
        self.loginId = getCommunityViewModel.SharedInstance.getCommunityList[indexPath.row].LoginId!
        cell?.btnFollow.tag = indexPath.row
        cell?.btnFollow.addTarget(self, action: #selector(AllCommunitiesView.btnJoinTapped(sender:)), for: .touchUpInside)
        
        //cell?.ProfilePic.setRounded()
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
extension AllCommunitiesView : getCommunityProtocol{
    func didSucess(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0 {
            self.tblAllCommunity.isHidden = true
            self.lblNoCommunity.isHidden = false
            self.lblNoCommunity.text = "Currently No Community Available."
        }
        else {
            self.lblNoCommunity.isHidden = true
            self.tblAllCommunity.isHidden = false
            self.tblAllCommunity.reloadData()
        }
    }
    func didFail(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.tblAllCommunity.isHidden = true
    }
}

extension AllCommunitiesView: requestCommunityProtocol {
    func didfail(Response: String) {
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
    func didSuccess(StatusCode: Int) {
        if StatusCode == 0 {
            self.view.makeToast("Successfully Joined to the Community.", duration: 3.0, position: .bottom)
            if getCommunityViewModel.SharedInstance.getCommunityList.count <= 0
            {
                self.tblAllCommunity.isHidden = true
                self.lblNoCommunity.isHidden = false
                self.lblNoCommunity.text = "Currently No Community Available."
            }
            else
            {
                self.lblNoCommunity.isHidden = true
                self.tblAllCommunity.isHidden = false
                self.tblAllCommunity.reloadData()
            }
        }else if StatusCode == 1 {
            self.view.makeToast("You are already member of this Community.", duration: 3.0, position: .bottom)
        }
    }
}
