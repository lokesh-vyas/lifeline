//
//  SignUpApi.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import Alamofire

//MARK:- SignUP Api
class SignUpApi {
    
    var userId = ""
    var Email = ""
    var password = ""
    
    var URL = URLList.LIFELINE_Custom_Sign_Up.rawValue
    var method = "POST"
  
    init(email:String, password:String ,userID:String) {
        self.Email = email
        self.password = password
        self.userId = userID
    }
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["UserIDAvilableityCheckRequest":["UserIDAvilableityCheckRequestDetails":[["UserID":self.userId],["Password":self.password],["Email":self.Email]]]]
        return parameters
    }
}
//MARK:- Check Avability
class CheckAvabilityApi {
   
    var UserID = ""
    var URL = URLList.LIFELINE_UserIDAvilableityCheck.rawValue
    var method = "POST"
    init(UserID:String) {
        self.UserID = UserID
      
    }
    
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["UserIDAvilableityCheckRequest":["UserIDAvilableityCheckRequestDetails":["UserID":self.UserID]]]
       return parameters 
    }
}
//MARK:- Forget Password
class ForgetPasswordApi {
    
    var UserID = ""
    var URL = URLList.LIFELINE_ForgetPassword.rawValue
    var method = "POST"
    init(UserID:String) {
        self.UserID = UserID
        
    }
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["ForgetPasswordRequest":["ForgetPasswordRequestDetails":["UserID":self.UserID]]]
        return parameters
    }
}

