//
//  SignUpInteractor.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK:- customLoginProtocol
protocol customLoginProtocol
{
    func successCustomLogin(success: Bool)
    func failCustomLogin(Response: String)
}
//MARK:- checkForgetPasswordProtocol
protocol checkForgetPasswordProtocol
{
    func successForgetPassword(success: Bool)
    func failSignUp(Response: String)
}
//MARK:- checkAvabilityProtocol
protocol checkAvabilityProtocol
{
    func checkAvailbaleSucess(success: Bool)
    func checkAvailbaleFail(Response: String)
}
//MARK:- successSignUpProtocol
protocol successSignUpProtocol
{
    func successSignUp(success: Bool)
    func failSignUp(Response: String)
}
//MARK:- SignUpInteractor
class SignUpInteractor
{
    class var SharedInstance : SignUpInteractor {
        struct Shared {
            static let Instance = SignUpInteractor()
        }
        return Shared.Instance
    }
    var delegate:checkAvabilityProtocol?
    var delegateSignUp:successSignUpProtocol?
    var delegateForgetPassword:checkForgetPasswordProtocol?
    var delegateLogin:customLoginProtocol?
    //MARK:- signUPCallForServices
    func signUPCallForServices(email:String, password:String ,userID:String,Name:String)
    {
        let builder = APIBuilder.sharedInstance.buildSignUpApi(emailID: email, Password: password, UserName: userID,Name:Name)
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                print(JSONResponse)
                if(JSONResponse["CustomSignUpResponse"]["CustomSignUpResponseDetails"]["StatusCode"].int == 0)
                {
                    self.delegateSignUp?.successSignUp(success: true)
                }else
                {
                    self.delegateSignUp?.successSignUp(success: false)
                }
        }, failure:
            { (Response) -> Void in
                self.delegateSignUp?.failSignUp(Response:Response)
        })
    }
    //MARK:- checkAvabilityCallForServices
    func checkAvabilityCallForServices(checkString:String)
    {
        let builder = APIBuilder.sharedInstance.buildCheckAvaibility(userID: checkString)
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                if(JSONResponse["UserIDAvilableityCheckResponse"]["UserIDAvilableityCheckResponseDetails"]["StatusCode"].int == 0)
                {
                    self.delegate?.checkAvailbaleSucess(success: true)
                }
                else
                {
                    self.delegate?.checkAvailbaleSucess(success: false)
                }
        }, failure:
            { (Response) -> Void in
                self.delegate?.checkAvailbaleFail(Response:Response)
        })
    }
    //MARK:- checkForgetPassword
    func checkForgetPassword(checkString:String)
    {
        let builder = APIBuilder.sharedInstance.buildForgetPasswordApi(userID: checkString)
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                print(JSONResponse)
                if(JSONResponse["ForgetPasswordResponse"]["ForgetPasswordResponseDetails"]["StatusCode"].int == 0)
                {
                    self.delegateForgetPassword?.successForgetPassword(success: true)
                }
                else
                {
                    self.delegateForgetPassword?.successForgetPassword(success: false)
                }
        }, failure:
            { (Response) -> Void in
                self.delegateForgetPassword?.failSignUp(Response:Response)
        })
    }
    //MARK:- checkcustomLogin
    func checkCustomLogin(UserID:String,Password:String)
    {
        let builder = APIBuilder.sharedInstance.buildLoginApi(Password: Password, UserName: UserID)
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                print(JSONResponse)
                if(JSONResponse["CustomLoginResponse"]["CustomLoginResponseDetails"]["StatusCode"].int == 0)
                {
                    let autoID:String = JSONResponse["CustomLoginResponse"]["CustomLoginResponseDetails"]["AutoID"].string!
                    UserDefaults.standard.set(autoID, forKey: StringList.LifeLine_User_ID.rawValue)
                    self.delegateLogin?.successCustomLogin(success: true)
                }
                else
                {
                     self.delegateLogin?.successCustomLogin(success: false)
                }
        }, failure:
            { (Response) -> Void in
                self.delegateLogin?.failCustomLogin(Response:Response)
        })
    }
}
