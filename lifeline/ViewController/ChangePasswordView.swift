//
//  ChangePasswordView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class ChangePasswordView: UIViewController {
    @IBOutlet weak var txtOldPassword: FloatLabelTextField!
    
    @IBOutlet weak var txtConfirmPassword: FloatLabelTextField!
    @IBOutlet weak var txtNewPassword: FloatLabelTextField!
    var Password : Bool?
    var ConfPassword : Bool?
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        self.textFieldPadding()
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordView.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        // Do any additional setup after loading the view.
    }
    func textFieldPadding()
    {
        txtNewPassword.setLeftPaddingPoints(10.0)
        txtOldPassword.setLeftPaddingPoints(10.0)
        txtConfirmPassword.setLeftPaddingPoints(10.0)
    }
    //MARK:- Back Button
    @IBAction func BackButton(_ sender: Any)
    {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    //MARK:- btnChangePasswordTapped
    @IBAction func btnChangePasswordTapped(_ sender: Any)
    {
        view.endEditing(true)
        if Password == true {
            if ConfPassword == true {
                
                if txtConfirmPassword.text == txtNewPassword.text {
                    
                    HudBar.sharedInstance.showHudWithMessage(message: "Please Wait...", view: self.view)
                    let data = UserDefaults.standard.object(forKey: "ProfileData")
                    
                    let profileData:ProfileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
                    
                    let customer : Dictionary = ["ChangePasswordRequest":["ChangePasswordRequestDetails":["UserID":profileData.EmailId,"OldPassword":txtOldPassword.text!,"NewPassword":txtNewPassword.text!]]]
                    self.ChangePasswordForService(params: customer)
                    
                } else {
                    self.view.makeToast("Password don't match", duration: 2.0, position: .bottom)
                }
                
            } else {
                self.view.makeToast("Confirm Password must be greater than 6 Digits", duration: 2.0, position: .bottom)
            }
        }else {
            self.view.makeToast("Password must be greater than 6 Digits", duration: 2.0, position: .bottom)
        }
    }
    //MARK:- Share Application URL With Activity
    func PushNotificationView(_ notification: NSNotification)
    {
        let dict = notification.object as! Dictionary<String, Any>
        
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .overCurrentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
    }
    //MARK:- MyRequestClose
    func ChangePasswordForService(params:Dictionary<String,Any>)
    {
        let urlString = URLList.LIFELINE_Change_Password.rawValue
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            print(JSONResponse)
                                                            HudBar.sharedInstance.hideHudFormView(view: self.view)
                                                            if (JSONResponse["ChangePasswordResponse"]["ChangePasswordResponseDetails"]["StatusCode"].int == 0)
                                                            {
                                                                HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Your Password is updated successfully", view: self.view)
                                                                let deadlineTime = DispatchTime.now() + .seconds(2)
                                                                DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
                                                                    {
                                                                        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                                                                        self.present(SWRevealView, animated: true, completion: nil)
                                                                })
                                                            }else
                                                            {
                                                                HudBar.sharedInstance.hideHudFormView(view: self.view)
                                                                HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Please enter valid old password", view: self.view)
                                                            }
        },
                                                         failure: {(Response) -> Void in
                                                            
                                                            
                                                            HudBar.sharedInstance.hideHudFormView(view: self.view)
                                                            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Please enter valid old password", view: self.view)
        }
        )
    }
}
//MARK:- TextFieldDelegate
extension ChangePasswordView:UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.characters.count == 0 {
            switch textField {
            case txtNewPassword:
                txtNewPassword.errorLine()
            case txtOldPassword:
                txtOldPassword.errorLine()
            case txtConfirmPassword:
                txtConfirmPassword.errorLine()
            default:
                print("E-Default case")
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let str = textField.text! as NSString
        let typedString = str.replacingCharacters(in: range, with: string)
        if typedString.characters.count > 0 {
            
            switch textField {
                
            case txtOldPassword:
                txtOldPassword.removeErrorLine()
                
            case txtNewPassword:
                
                if typedString.characters.count >= 6
                {
                    txtNewPassword.removeErrorLine()
                    Password = true
                } else {
                    txtNewPassword.errorLine()
                    Password = false
                }
                
            case txtConfirmPassword:
                
                if typedString.characters.count >= 6
                {
                    txtConfirmPassword.removeErrorLine()
                    ConfPassword = true
                } else {
                    txtConfirmPassword.errorLine()
                    ConfPassword = false
                }
                
            default:
                print("TODO")
            }
            
        }
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
}

