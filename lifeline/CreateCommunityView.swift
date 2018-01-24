//
//  CreateCommunityView.swift
//  lifeline
//
//  Created by Anjali on 30/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateCommunityView: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtName: UITextField!
    //@IBOutlet weak var changeImage: UIImageView!
    @IBOutlet weak var btnCloseGroup: UIButton!
    @IBOutlet weak var btnOpenGroup: UIButton!
    @IBOutlet weak var createCommunityScrollView: UIScrollView!
    var groupType: String?
    let button = UIButton(frame: CGRect(x: 14, y: -7, width: 18, height: 18))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        //changeImage.setRounded()
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black
        button.setBackgroundImage(UIImage(named: "Edit"), for: .normal)
        button.addTarget(self, action: #selector(BtnChangeProfilePicTapped), for: .touchUpInside)
        //changeImage.addSubview(button)
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateCommunityView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateCommunityView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.txtContactName.delegate = self
        self.txtContactNumber.delegate = self
        self.txtName.delegate = self
        self.txtViewDescription.delegate = self
        self.groupType = "Closed"
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
    //MARK:- keyboard Appear / DisAppear
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset:UIEdgeInsets = self.createCommunityScrollView.contentInset
            contentInset.bottom = keyboardSize.size.height
            self.createCommunityScrollView.contentInset = contentInset
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.createCommunityScrollView.contentInset = contentInset
        }
    }
    func BtnChangeProfilePicTapped() {
        print("Success")
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnOpenGroupTapped(_ sender: Any) {
            btnOpenGroup.setImage(UIImage(named : "redio_on"), for: .normal)
            btnCloseGroup.setImage(UIImage(named : "radio_off"), for: .normal)
            self.groupType = "Open"
    }
    @IBAction func btnCloseGroupTapped(_ sender: Any) {
        btnOpenGroup.setImage(UIImage(named : "radio_off"), for: .normal)
        btnCloseGroup.setImage(UIImage(named : "redio_on"), for: .normal)
        self.groupType = "Closed"
    }
    @IBAction func btnCreateTapped(_ sender: Any) {
        view.endEditing(true)
        if((txtName.text?.characters.count)! < 1 || (txtViewDescription.text.characters.count) < 1 || (txtContactName.text?.characters.count)! < 1) {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_ALL_MANDATORY_NEW_FIELDS"), duration: 2.0, position: .bottom)
        }else {
            HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_SUBMIT_MESSAGE"), view: self.view)
            getCommunityViewModel.SharedInstance.delegate = self 
            getCommunityViewModel.SharedInstance.createCommunity(name: self.txtName.text!, description: self.txtViewDescription.text, type: self.groupType!, phone: self.txtContactNumber.text!, logo: "http://logo.com", contactName: self.txtContactName.text!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension CreateCommunityView : getCommunityProtocol{
    func didSucess(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Community Created Successfully ", view: self.view)
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.navigationController?.present(SWRevealView, animated: true, completion: nil)
        })
    }
    func didFail(){
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
    }
}
