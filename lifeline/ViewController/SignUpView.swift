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
    
    @IBOutlet weak var signUpScroll: UIScrollView!
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
        nameTextField.removeLoginErrorLine()
        passwordTextField.removeLoginErrorLine()
        emailTextField.removeLoginErrorLine()
        confirmTextField.removeLoginErrorLine()
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.completelyTransparentBar()
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK:- keyboard Appear / DisAppear
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset:UIEdgeInsets = self.signUpScroll.contentInset
            contentInset.bottom = keyboardSize.size.height - 150
            self.signUpScroll.contentInset = contentInset
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.signUpScroll.contentInset = contentInset
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- checkAvability
    @IBAction func checkAvability(_ sender: Any)
    {
        // view.endEditing(true)
        //        if (userIDTextField.text?.characters.count)! > 3
        //        {
        //            SignUpInteractor.SharedInstance.delegate = self
        //            SignUpInteractor.SharedInstance.checkAvabilityCallForServices(checkString: userIDTextField.text!)
        //        }
        //        else
        //        {
        //            self.view.makeToast("User Id should be greater than three characters", duration: 3.0, position: .bottom)
        //        }
    }
    //MARK:- BackButtonAction
    
    //MARK:- signUpAction
    @IBAction func btnSignUpTapped(_ sender: Any) {
        
        view.endEditing(true)
        if (Email == nil || Password == nil || (emailTextField.text?.characters.count)! < 1 || (confirmTextField.text?.characters.count)! < 1 || (nameTextField.text?.characters.count)! < 1)
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_ALL_MANDATORY_NEW_FIELDS"), duration: 2.0, position: .bottom)
            
        }else if (Email == true) {
            if Password == true {
                if passwordTextField.text == confirmTextField.text {
                    
                    HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_SIGN_IN"), view: self.view)
                    SignUpInteractor.SharedInstance.delegateSignUp = self
                    SignUpInteractor.SharedInstance.signUPCallForServices(email: self.emailTextField.text!, password: self.passwordTextField.text!, userID: self.emailTextField.text!,Name:self.nameTextField.text!)
                    
                } else {
                    self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_PASSWORD_NOT_MATCHED"), duration: 2.0, position: .bottom)
                }
                
            } else {
                self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_PASSWORD_VALIDATION"), duration: 2.0, position: .bottom)
            }
        } else {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_INVALID_MAIL_ID"), duration: 2.0, position: .bottom)
        }
        
    }
    @IBAction func btnSignInTapped(_ sender: Any)
    {
        let viewController:LoginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
        
        viewController.modalPresentationStyle =  .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
        
    }
}
//MARK:- TextFieldDelegate
extension SignUpView:UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.characters.count == 0 {
            switch textField {
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
                
            case nameTextField:
                nameTextField.removeLoginErrorLine()
                
            case emailTextField:
                if typedString.isValidEmail(){
                    emailTextField.removeLoginErrorLine()
                    Email = true
                    
                } else {
                    emailTextField.errorLine()
                    Email = false
                }
            case passwordTextField:
                
                if typedString.characters.count >= 6
                {
                    passwordTextField.removeLoginErrorLine()
                    Password = true
                } else {
                    passwordTextField.errorLine()
                    Password = false
                }
                
                
            case confirmTextField:
                
                if typedString.characters.count >= 6
                {
                    confirmTextField.removeLoginErrorLine()
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
//MARK:- checkAvabilityProtocol
extension SignUpView : checkAvabilityProtocol
{
    func checkAvailbaleSucess(success: Bool)
    {
        if success
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("SUCESS_USER_ID_AVAILABLE"), view: self.view)
        }
        else
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("ERROR_WRONG_USER_ID"), view: self.view)
        }
    }
    func checkAvailbaleFail(Response:String)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
//MARK:- successSignUpProtocol
extension SignUpView : successSignUpProtocol
{
    func successSignUp(success: Bool)
    {
        if success == true
        {
            UserDefaults.standard.set(self.nameTextField.text, forKey: StringList.LifeLine_User_Name.rawValue)
            UserDefaults.standard.set(self.emailTextField.text, forKey: StringList.LifeLine_User_Email.rawValue)
            
            let trimmedString = self.emailTextField.text?.trimmingCharacters(in: .whitespaces)
            SignUpInteractor.SharedInstance.delegateLogin = self
            SignUpInteractor.SharedInstance.checkCustomLogin(UserID: trimmedString!, Password: self.passwordTextField.text!)
        }
        else
        {
            self.emailTextField.errorLine()
            Email = false
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("ERROR_WRONG_USER_ID"), view: self.view)
        }
    }
    func failSignUp(Response:String)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
extension SignUpView : customLoginProtocol
{
    func successCustomLogin(success: Bool)
    {
        if success == true
        {
            UserDefaults.standard.set("Internal", forKey: "LoginInformation")
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("SUCESS_LOGIN_MESSAGE"), view: self.view)
            
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            
            let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView")
            let navigationController = UINavigationController.init(rootViewController: profileView!)
            self.present(navigationController, animated: true, completion: nil)
        }
        else
        {
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("ERROR_INCORRECT_USERID_PASSWORD"), view: self.view)
        }
    }
    func failCustomLogin(Response:String)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}

