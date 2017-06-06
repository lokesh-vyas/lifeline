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
    var Name = ""
    
    var URL = URLList.LIFELINE_Custom_Sign_Up.rawValue
    var method = "POST"
  
    init(email:String, password:String ,userID:String,name:String) {
        self.Email = email
        self.password = password
        self.userId = userID
        self.Name = name
    }
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["CustomSignUpRequest":["CustomSignUpRequestDetails":["Name":self.Name,"UserID":self.userId,"Password":self.password,"Email":self.Email]]]
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
//MARK:- CustomLoginApi
class CustomLoginApi
{
    var userId = ""
    var password = ""
    
    var URL = URLList.LIFELINE_CustomLogin.rawValue
    var method = "POST"
    
    init(userID:String,password:String) {
        self.password = password
        self.userId = userID
    }
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["CustomLoginRequest":["CustomLoginRequestDetails":[["UserID":self.userId],["Password":self.password]]]]
        return parameters
    }
}
//MARK:- Gat Profile List
class GetProfileData {
    
    var UserID = ""
    var URL = URLList.LIFELINE_Get_Profile.rawValue
    var method = "POST"
    init(UserID:String) {
        self.UserID = UserID
        
    }
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["GetProfileRequest":["GetProfileRequestDetails":[["LoginId":self.UserID],["LoginName":""]]]]
        return parameters
    }
}
