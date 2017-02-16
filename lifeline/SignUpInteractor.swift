//
//  SignUpInteractor.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol checkAvabilityProtocol
{
    func checkAvailbaleSucess(success: Bool)
    func checkAvailbaleFail()
}

class SignUpInteractor
{
    class var SharedInstance : SignUpInteractor {
        struct Shared {
            static let Instance = SignUpInteractor()
        }
        return Shared.Instance
    }
    var delegate:checkAvabilityProtocol?
    
    func signUPCallForServices(checkString:String,sucess:() -> Void ,filure:() -> Void)
    {
        let builder = APIBuilder.sharedInstance.buildSignUpApi(userID: checkString)
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                print(JSONResponse)
                if(JSONResponse["UserIDAvilableityCheckResponse"]["UserIDAvilableityCheckResponseDetails"]["StatusCode"].int == 0)
                {
                    self.delegate?.checkAvailbaleSucess(success: true)
                }
                else
                {
                    self.delegate?.checkAvailbaleSucess(success: false)
                }
        }, failure:
            { _ in
                self.delegate?.checkAvailbaleFail()
        })
    }
}
