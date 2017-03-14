//
//  LoginView.swift
//  lifeline
//
//  Created by iSteer on 10/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Google
import GoogleSignIn

class LoginView: UIViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var userNameTextField: FloatLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: FloatLabelTextField!
    var Email : Bool?
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK:- ViewWill Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userNameTextField.removeLoginErrorLine()
        passwordTextField.removeLoginErrorLine()
        self.navigationController?.navigationBar.isHidden = true
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor))
        {
            statusBar.backgroundColor = UIColor.clear
        }
    }
    //MARK:- SignUpAction
    @IBAction func btnSignUpTapped(_ sender: Any) {
        let viewController:SignUpView = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpView
        
        viewController.modalPresentationStyle =  .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    //MARK:- Forgot Password
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        self.view.endEditing(true)
        if (userNameTextField.text?.characters.count)! < 1
        {
            self.view.makeToast("Please enter UserID", duration: 3.0, position: .bottom)
            return
        }
        let trimmedString = self.userNameTextField.text?.trimmingCharacters(in: .whitespaces)
        SignUpInteractor.SharedInstance.delegateForgetPassword = self
        SignUpInteractor.SharedInstance.checkForgetPassword(checkString:trimmedString!)
    }
    //MARK:- CustomLogin
    @IBAction func btnCustomSignIn(_ sender: Any) {
        self.view.endEditing(true)
        if((userNameTextField.text?.characters.count)! <= 0)
        {
            self.view.makeToast("Please enter Email Address", duration: 2.0, position: .bottom)
        }
        else if((passwordTextField.text?.characters.count)! <= 0)
        {
            self.view.makeToast("Please enter Password", duration: 2.0, position: .bottom)
        }
        else
        {
            HudBar.sharedInstance.showHudWithMessage(message: "Login...", view: self.view)
            let trimmedString = self.userNameTextField.text?.trimmingCharacters(in: .whitespaces)
            SignUpInteractor.SharedInstance.delegateLogin = self
            SignUpInteractor.SharedInstance.checkCustomLogin(UserID: trimmedString!, Password: self.passwordTextField.text!)
        }

    }
    //MARK:- FB Login
    @IBAction func btnFacrbookTapped(_ sender: Any) {
        HudBar.sharedInstance.showHudWithMessage(message: "Logging", view: self.view)
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self)
        {
            loginResult in
            switch loginResult {
            case .failed( _):
                HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Fail to Login", view: self.view)
            case .cancelled:
                HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Cancel", view: self.view)
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.getFBUserData()
                
            }
        }
    }
   
    func getFBUserData()
    {
        if AccessToken.current != nil
        {
            let connection = GraphRequestConnection()
            
            connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"])) { httpResponse, result in
                switch result {
                case .success(let response):
                    HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: StringList.LL_Welcome_Message.rawValue, view: self.view)
                    UserDefaults.standard.set("Facebook", forKey: "LoginInformation")
                    UserDefaults.standard.set(response.dictionaryValue?["id"], forKey: StringList.LifeLine_User_ID.rawValue)
                    UserDefaults.standard.set(response.dictionaryValue?["name"], forKey: StringList.LifeLine_User_Name.rawValue)
                    UserDefaults.standard.set(response.dictionaryValue?["email"], forKey: StringList.LifeLine_User_Email.rawValue)
                    self.goToProfileView()
                    
                case .failed(let error):
                    print("Graph Request Failed: \(error)")
                    HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Fail to Login", view: self.view)
                }
            }
            connection.start()
        }
    }
    //MARK:- Go To ProfileView
    func goToProfileView()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        let profileView = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView")
        let navigationController = UINavigationController.init(rootViewController: profileView!)
        self.present(navigationController, animated: true, completion: nil)
    }
    //MARK:- G+ Login
    @IBAction func btnGoogleLoginTapped(_ sender: Any) {
        HudBar.sharedInstance.showHudWithMessage(message: "Logging", view: self.view)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().clientID = StringList.GoogleClientID.rawValue
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/plus.login","https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile"]
        GIDSignIn.sharedInstance().signIn()
    }
 
}
extension LoginView:GIDSignInUIDelegate,GIDSignInDelegate
{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Cancel", view: self.view)
            print("\(error.localizedDescription)")
        }
        else
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: StringList.LL_Welcome_Message.rawValue, view: self.view)
            UserDefaults.standard.set("G+", forKey: "LoginInformation")
            UserDefaults.standard.set(user.userID, forKey: StringList.LifeLine_User_ID.rawValue)
            UserDefaults.standard.set(user.profile.name, forKey: StringList.LifeLine_User_Name.rawValue)
            UserDefaults.standard.set(user.profile.email, forKey: StringList.LifeLine_User_Email.rawValue)
            self.goToProfileView()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}
extension LoginView:checkForgetPasswordProtocol
{
    func successForgetPassword(success: Bool)
    {
        if success
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "You will shortly recive mail in your registered Email id with the new password", view: self.view)
        }
        else
        {
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Type your UserID Correctly", view: self.view)
        }
    }
    func failSignUp()
    {
        self.view.makeToast("Unable to access server, please try again later", duration: 3.0, position: .bottom)
    }
}
extension LoginView : customLoginProtocol
{
    func successCustomLogin(success: Bool)
    {
        if success == true
        {
             UserDefaults.standard.set("Internal", forKey: "LoginInformation")
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "User Login Successfully", view: self.view)
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                 self.goToProfileView()
            })
        }
        else
        {
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Please Check your UserID And Password and try again", view: self.view)
        }
    }
    func failCustomLogin()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.view.makeToast("Unable to access server, please try again later", duration: 2.0, position: .bottom)
    }
}
//MARK:- TextFieldDelegate
extension LoginView:UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.characters.count == 0 {
            switch textField {
            case userNameTextField:
                userNameTextField.errorLine()
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
           
            case userNameTextField:
                if typedString.isValidEmail(){
                    userNameTextField.removeLoginErrorLine()
                    Email = true
                    
                } else {
                    userNameTextField.errorLine()
                    Email = false
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
