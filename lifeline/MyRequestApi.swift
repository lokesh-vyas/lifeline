//
//  MyRequestApi.swift
//  lifeline
//
//  Created by iSteer on 27/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import Alamofire

//MARK:- Check Avability
class MyRequestApi {
    
    var UserID = ""
    var URL = URLList.MY_REQUESTS.rawValue
    var method = "POST"
    init(LoginID:String) {
        self.UserID = LoginID
        
    }
    
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["MyRequestsRequest":["RequestDetails":[["LoginID":self.UserID],["Status":""]]]]
        return parameters
    }
}
