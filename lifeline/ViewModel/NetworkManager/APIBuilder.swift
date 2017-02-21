//
//  APIBuilder.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

class APIBuilder
{
    static let sharedInstance : APIBuilder =
        {
            let instance = APIBuilder()
            return instance
    }()
    
    //MARK:- CHECKAVABILITY Api
    func buildSignUpApi(userID:String) -> CheckAvabilityApi
    {
        let api = CheckAvabilityApi(UserID: userID)
        return api
    }
    //MARK:- Hospital List View API
    func buildHospitalListView(searchString:String) -> HospitalListApi {
        let api = HospitalListApi(SearchStr: searchString)
        return api
    }
}
