//
//  UpdateCommunityView.swift
//  lifeline
//
//  Created by Anjali on 07/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit

class UpdateCommunityView: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtName: UITextField!
    //@IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var updateScrollView: UIScrollView!
    @IBOutlet weak var btnOpenGroup: UIButton!
    @IBOutlet weak var btnCloseGroup: UIButton!
    var groupType: String?
    var communityId: Int?
    let button = UIButton(frame: CGRect(x: 14, y: -7, width: 18, height: 18))
    var updateCommunityJSON:Dictionary<String, Any> = Dictionary<String, Any>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        //imgProfile.setRounded()
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black
        button.setBackgroundImage(UIImage(named: "Edit"), for: .normal)
        button.addTarget(self, action: #selector(BtnChangeProfilePicTapped), for: .touchUpInside)
        //imgProfile.addSubview(button)
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateCommunityView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateCommunityView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.txtContactName.delegate = self
        self.txtContactNumber.delegate = self
        self.txtName.delegate = self
        self.txtViewDescription.delegate = self
        self.groupType = updateCommunityJSON["Type"] as? String
        txtName.text = updateCommunityJSON["Name"] as? String
        txtViewDescription.text = updateCommunityJSON["Description"] as? String
//        if let a = updateCommunityJSON["ContactNumber"], let b: String = a as? String {
//                txtContactNumber.text = String(describing: b)
//        }
        txtContactNumber.text = String(describing: updateCommunityJSON["ContactNumber"]!)
        txtContactName.text = updateCommunityJSON["ContactName"] as? String
        if self.groupType == "Closed" {
            btnOpenGroup.setImage(UIImage(named : "radio_off"), for: .normal)
            btnCloseGroup.setImage(UIImage(named : "redio_on"), for: .normal)
            self.groupType = "Closed"
        }else {
            btnOpenGroup.setImage(UIImage(named : "redio_on"), for: .normal)
            btnCloseGroup.setImage(UIImage(named : "radio_off"), for: .normal)
            self.groupType = "Open"
        }
        self.communityId = updateCommunityJSON["CommunityId"] as? Int
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
    func BtnChangeProfilePicTapped() {
        print("Success")
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCloseGroupTapped(_ sender: Any) {
        btnOpenGroup.setImage(UIImage(named : "radio_off"), for: .normal)
        btnCloseGroup.setImage(UIImage(named : "redio_on"), for: .normal)
        self.groupType = "Closed"
    }
    @IBAction func btnOpenGroupTapped(_ sender: Any) {
        btnOpenGroup.setImage(UIImage(named : "redio_on"), for: .normal)
        btnCloseGroup.setImage(UIImage(named : "radio_off"), for: .normal)
        self.groupType = "Open"
    }
    @IBAction func btnUpdateTapped(_ sender: Any) {
        view.endEditing(true)
        if((txtName.text?.characters.count)! < 1 || (txtViewDescription.text.characters.count) < 1 || (txtContactName.text?.characters.count)! < 1) {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_ALL_MANDATORY_NEW_FIELDS"), duration: 2.0, position: .bottom)
        }else {
            HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_SUBMIT_MESSAGE"), view: self.view)
            UpdateViewModel.SharedInstance.delegate = self
            UpdateViewModel.SharedInstance.updateCommunity(name: self.txtName.text!, description: self.txtViewDescription.text, type: self.groupType!, phone: self.txtContactNumber.text!, logo: "http://logo.com", contactName: self.txtContactName.text!, communityId: self.communityId!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //MARK:- keyboard Appear / DisAppear
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset:UIEdgeInsets = self.updateScrollView.contentInset
            contentInset.bottom = keyboardSize.size.height
            self.updateScrollView.contentInset = contentInset
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.updateScrollView.contentInset = contentInset
        }
    }
}
extension UpdateCommunityView : updateProtocol{
    func didFail(Response: String) {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
    func didSuccess() {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Requested Details Updated Successfully.", view: self.view)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.navigationController?.present(SWRevealView, animated: true, completion: nil)
        })
    }
    
    
}
