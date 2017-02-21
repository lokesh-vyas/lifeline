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
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //MARK:- ViewWill Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK:- SignUpAction
    @IBAction func signUpAction(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpView") as! SignUpView
 
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    //MARK:- Forgot Password
    @IBAction func forgotPasswordAction(_ sender: Any)
    {
        
    }
    //MARK:- CustomLogin
    @IBAction func customLoginAction(_ sender: Any)
    {
        if((userNameTextField.text?.characters.count)! <= 0)
        {
            self.view.makeToast("Please enter User ID", duration: 2.0, position: .bottom)
        }
        else if((passwordTextField.text?.characters.count)! <= 0)
        {
            self.view.makeToast("Please enter Password", duration: 2.0, position: .bottom)
        }
        else
        {
            //TODO:- Sevice Call
        }
    }
    //MARK:- FB Login
    @IBAction func facebookLogin(_ sender: Any)
    {
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
    func goToProfileView()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        let reavalView = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
          self.present(reavalView!, animated: true, completion: nil)
    }
    //MARK:- G+ Login
    @IBAction func googleLogin(_ sender: Any)
    {
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
