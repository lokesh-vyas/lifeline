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
    func serviceCallForPOST(url:String, method:String, parameters:Parameters, sucess:@escaping (JSON) -> Void, failure:@escaping () -> Void)
    {
        print("----------\(parameters)-------")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "apikey": "ALDZ5abmAnppumwtjIdMBQU1SqHgL12G"
        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                print("----------\(response.request!)----------")
                
                if let temp = response.response {
                    print("Getting response from Servdr !!", temp)
                    
                } else {
                    if (response.result.error as? AFError) != nil {
                        failure()
                    }
                    print("Couldn't get Response from Server !!")
                    failure()
                }
//                print(response.data!)
//                print(response.result)
                if response.result.isSuccess {
                    let resJson = JSON(response.result.value!)
                    if !resJson.isEmpty {
                        sucess(resJson)
                    } else {
                        failure()
                    }
                }
                if response.result.isFailure {
                    failure()
                }
        }
        
    }
}
