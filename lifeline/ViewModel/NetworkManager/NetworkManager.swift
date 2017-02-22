//
//  NetworkManager.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager
{
    static let sharedInstance : NetworkManager =
        {
            let instance = NetworkManager()
            return instance
    }()
    var sessionManager = Alamofire.SessionManager()
    //SingleTon Object
    
    //MARK:- Alamofire Implementation With Header
    init() {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    func serviceCallForPOSTforHTTPS()
    {
        let manager = NetworkReachabilityManager(host: "api.lifeline.services")
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
        }
        manager?.startListening()
    }
    func serviceCallForPOST(url:String,method:String,parameters:Parameters,sucess:@escaping (JSON) -> Void,failure:@escaping () -> Void)
    {
        print(parameters)
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                print(response.request!)
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)
                
                if response.result.isSuccess
                {
                    let resJson = JSON(response.result.value!)
                    sucess(resJson)
                }
                if response.result.isFailure
                {
                    failure()
                }
        }
        
    }
    func serviceCallForGET(url:String,method:String,sucess:(JSON) -> Void,failure:() -> Void)
    {
    }
}