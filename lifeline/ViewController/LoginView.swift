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

class LoginView: UIViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK:- ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       // Do any additional setup after loading the view.
    }
    //MARK:- SignUpAction
    @IBAction func signUpAction(_ sender: Any)
    {
        
    }
    //MARK:- Forgot Password
    @IBAction func forgotPasswordAction(_ sender: Any)
    {
    }
    //MARK:- CustomLogin
    @IBAction func customLoginAction(_ sender: Any)
    {
       
    }
    //MARK:- FB Login
    @IBAction func facebookLogin(_ sender: Any)
    {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile], viewController: self)
        {
            loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
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
                     print("Graph Request Failed: \(response)")
                     
                case .failed(let error):
                    print("Graph Request Failed: \(error)")
                }
            }
            connection.start()
        }
        
    }
    //MARK:- G+ Login
    @IBAction func googleLogin(_ sender: Any)
    {
       
    }
}
