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

    //MARK:- buildSignUpApi
    func buildSignUpApi(emailID: String, Password: String, UserName: String) -> SignUpApi
    {
        let api = SignUpApi(email: emailID, password: Password, userID: UserName)
        return api
    }
    //MARK:- Hospital List View API
    func buildHospitalListView(searchString:String) -> HospitalListApi {
        let api = HospitalListApi(SearchStr: searchString)
        return api
    }
    //MARK:- buildCheck Avaibility
    func buildCheckAvaibility(userID:String) -> CheckAvabilityApi
    {
        let api = CheckAvabilityApi(UserID: userID)
        return api
    }
    //MARK:- buildCheck Avaibility
    func buildForgetPasswordApi(userID:String) -> ForgetPasswordApi
    {
        let api = ForgetPasswordApi(UserID: userID)
        return api
    }
    //MARK:- buildLoginApi
    func buildLoginApi(Password: String, UserName: String) -> CustomLoginApi
    {
        let api = CustomLoginApi(userID: UserName, password: Password)
        return api
    }
    
   }
