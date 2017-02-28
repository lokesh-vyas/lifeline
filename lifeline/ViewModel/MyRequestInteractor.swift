//
//  MyRequestInteractor.swift
//  lifeline
//
//  Created by iSteer on 27/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK:- MyRequestProtocol
protocol MyRequestProtocol
{
    func SuccessMyRequest(JSONResponse: JSON)
    func FailMyRequest()
}
//MARK:- MyRequestInteractor
class MyRequestInteractor
{
    static let SharedInstance : MyRequestInteractor = {
        let instance = MyRequestInteractor()
        return instance
    }()
    var delegate:MyRequestProtocol?
    
    //MARK:- MyRequestServiceCall
    func MyRequestServiceCall(loginID:String)
    {
        let builder = APIBuilder.sharedInstance.buildMyRequestDeatils(LoginID: loginID)
       
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                self.delegate?.SuccessMyRequest(JSONResponse: JSONResponse)
        }, failure:
            { _ in
                self.delegate?.FailMyRequest()
        })
    }
}
