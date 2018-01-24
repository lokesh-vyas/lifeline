//
//  CreateInviteView.swift
//  lifeline
//
//  Created by Anjali on 11/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateInviteView: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var txtEmail: FloatLabelTextField!
    var adminCommunityId = Int()
    var memberInvite:Dictionary<String, Any> = Dictionary<String, Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        self.adminCommunityId = memberInvite["CommunityId"] as! Int
        self.txtEmail.delegate = self
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
    @IBAction func btnInviteTapped(_ sender: Any) {
        view.endEditing(true)
        if(txtEmail.text?.characters.count)! < 1 {
            self.view.makeToast("Please Enter Email Address", duration: 2.0, position: .bottom)
        }else {
            HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_SUBMIT_MESSAGE"), view: self.view)
            UpdateCommunityMemberModel.SharedInstance.delegate = self
            UpdateCommunityMemberModel.SharedInstance.createInvite(emailId: self.txtEmail.text!, communityId: self.adminCommunityId, invitationStatus: "Pending")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}
extension CreateInviteView: updateCommunityMemberProtocol {
    func didSuccess(StatusCode: Int) {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if StatusCode == 0 {
            self.view.makeToast("Invitation sent Successfully.", duration: 9.0, position: .bottom)
            let inviteView:AdminInviteView = self.storyboard?.instantiateViewController(withIdentifier: "AdminInviteView") as! AdminInviteView
            inviteView.AdminInviteJSON["CommunityId"] = self.adminCommunityId
            let rootView:UINavigationController = UINavigationController(rootViewController: inviteView)
            self.present(rootView, animated: true, completion: nil)
            
        }else if StatusCode == 1 {
            self.view.makeToast("This Email ID is not registered in LifeLine.", duration: 9.0, position: .bottom)
            let inviteView:AdminInviteView = self.storyboard?.instantiateViewController(withIdentifier: "AdminInviteView") as! AdminInviteView
            inviteView.AdminInviteJSON["CommunityId"] = self.adminCommunityId
            let rootView:UINavigationController = UINavigationController(rootViewController: inviteView)
            self.present(rootView, animated: true, completion: nil)
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
