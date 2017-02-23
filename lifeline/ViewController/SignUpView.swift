//
//  SignUpView.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import Toast_Swift

class SignUpView: UIViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var userIDTextField: FloatLabelTextField!
    @IBOutlet weak var nameTextField: FloatLabelTextField!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    @IBOutlet weak var confirmTextField: FloatLabelTextField!
    var Email : Bool?
    var Password : Bool?
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.completelyTransparentBar()
    }
    //MARK:- checkAvability
    @IBAction func checkAvability(_ sender: Any)
    {
        view.endEditing(true)
        if (userIDTextField.text?.characters.count)! > 3
        {
            SignUpInteractor.SharedInstance.delegate = self
            SignUpInteractor.SharedInstance.checkAvabilityCallForServices(checkString: userIDTextField.text!)
        }
        else
        {
            self.view.makeToast("User Id should be greater than three characters", duration: 3.0, position: .bottom)
        }
    }
    //MARK:- BackButtonAction
    @IBAction func BackButtonAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- signUpAction
    @IBAction func signUpAction(_ sender: Any)
    {
        view.endEditing(true)
        
        if (userIDTextField.text?.characters.count)! < 3
        {
            self.view.makeToast("User Id should be greater than three characters", duration: 3.0, position: .bottom)
            return
        }
        if (userIDTextField.text?.characters.count)! < 1 || Email == nil || Password == nil || (emailTextField.text?.characters.count)! < 1 || (confirmTextField.text?.characters.count)! < 1 || (nameTextField.text?.characters.count)! < 1
        {
            self.view.makeToast("Please fill all fields", duration: 2.0, position: .bottom)
            
        } else if (userIDTextField.text?.characters.count)! > 1 {
            if Email == true {
                if Password == true {
                    if passwordTextField.text == confirmTextField.text {
                        
                        HudBar.sharedInstance.showHudWithMessage(message: "Signin...", view: self.view)
                        SignUpInteractor.SharedInstance.delegateSignUp = self
                        SignUpInteractor.SharedInstance.signUPCallForServices(email: self.emailTextField.text!, password: self.passwordTextField.text!, userID: self.userIDTextField.text!)
                        
                    } else {
                        self.view.makeToast("Password mismatch", duration: 2.0, position: .bottom)
                    }
                    
                } else {
                    self.view.makeToast("Password must be greater than 6 Digits", duration: 2.0, position: .bottom)
                }
            } else {
                self.view.makeToast("Invalid Email ID", duration: 2.0, position: .bottom)
            }
        } else {
            self.view.makeToast("Minimum Two Characters Required", duration: 2.0, position: .bottom)
        }
    }
}
//MARK:- TextFieldDelegate
extension SignUpView:UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.characters.count == 0 {
            switch textField {
            case userIDTextField:
                userIDTextField.errorLine()
                
            case nameTextField:
                nameTextField.errorLine()
            case passwordTextField:
                passwordTextField.errorLine()
            case emailTextField:
                emailTextField.errorLine()
            case confirmTextField:
                confirmTextField.errorLine()
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
            case userIDTextField:
                if typedString.characters.count > 3
                {
                    userIDTextField.removeErrorLine()
                } else {
                    userIDTextField.errorLine()
                }
                
                
            case nameTextField:
                nameTextField.removeErrorLine()
                
            case emailTextField:
                if typedString.isValidEmail(){
                    emailTextField.removeErrorLine()
                    Email = true
                    
                } else {
                    emailTextField.errorLine()
                    Email = false
                }
            case passwordTextField:
                
                if typedString.characters.count >= 6
                {
                    passwordTextField.removeErrorLine()
                    Password = true
                } else {
                    passwordTextField.errorLine()
                    Password = false
                }
                
                
            case confirmTextField:
                
                if typedString.characters.count >= 6
                {
                    confirmTextField.removeErrorLine()
                    Password = true
                } else {
                    confirmTextField.errorLine()
                    Password = false
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
extension SignUpView : checkAvabilityProtocol
{
    func checkAvailbaleSucess(success: Bool)
    {
        if success
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "User id is available", view: self.view)
        }
        else
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "User id you entered is already in use please enter another user id", view: self.view)
        }
    }
    func checkAvailbaleFail()
    {
        self.view.makeToast("Unable to access server, please try again later", duration: 3.0, position: .bottom)
    }
}
extension SignUpView : successSignUpProtocol
{
    func successSignUp(success: Bool)
    {
        if success == true
        {
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "User Registered Successfully", view: self.view)
            UserDefaults.standard.set(self.nameTextField.text, forKey: StringList.LifeLine_User_Name.rawValue)
            UserDefaults.standard.set(self.emailTextField.text, forKey: StringList.LifeLine_User_Email.rawValue)
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
                {
                    self.navigationController?.popViewController(animated: true)
            })
        }
        else
        {
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "User id you entered is already in use please enter another user id", view: self.view)
        }
        
    }
    func failSignUp()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.view.makeToast("Unable to access server, please try again later", duration: 2.0, position: .bottom)
    }
}
