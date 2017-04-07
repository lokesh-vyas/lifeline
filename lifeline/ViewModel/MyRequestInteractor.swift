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
    func SuccessMyRequest(JSONResponse: JSON,Sucess:Bool)
    func FailMyRequest(Response:String)
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
                if(JSONResponse["MyRequestsResponse"]["MyRequestsResponseDetails"]["StatusCode"].int == 1)
                {
                    self.delegate?.SuccessMyRequest(JSONResponse: JSONResponse,Sucess:false)
                }
                else
                {
                    self.delegate?.SuccessMyRequest(JSONResponse: JSONResponse,Sucess:true)
                }
        }, failure:
            { (Response) -> Void in
                self.delegate?.FailMyRequest(Response:Response)
        })
    }
    //MARK:- MyRequestClose
    func MyRequestClose(params:Dictionary<String,Any>)
    {
        let urlString = URLList.REQUEST_STATUS_UPDATE.rawValue
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            self.delegate?.SuccessMyRequest(JSONResponse: JSONResponse,Sucess:true)
        },
                                                         failure: { (Response) -> Void in
                                                            self.delegate?.FailMyRequest(Response:Response)
        }
        )
    }
}
