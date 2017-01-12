//
//  SignUpApi.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import Alamofire

class SignUpApi {
    
    var userName = ""
    var email = ""
    var password = ""
    
    var URL = URLList.LIFELINE_UserIDAvilableityCheck.rawValue
    var method = "POST"
  
    init(email:String, password:String ,userName:String) {
        self.email = email
        self.password = password
        self.userName = userName
    }
    
    func makeParams() -> [String:String]
    {
       var params = [String:String]()
        params["email"] = self.email
        params["password"] = self.password
        params["username"] = self.userName
        params["avatar"] = "img/avatar/undefined.png"
        
        return params
        
    }
}
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
