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

   var sessionManager : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            URLList.TrustHostProd.rawValue: .disableEvaluation
        ]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let sessionManager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return sessionManager
    }()
    //SingleTon Object

    func serviceCallForPOSTforHTTPS()
    {
        let manager = NetworkReachabilityManager(host: "api.lifeline.services")
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
        }
        manager?.startListening()
    }
    func serviceCallForPOST(url:String, method:String, parameters:Parameters, sucess:@escaping (JSON) -> Void, failure:@escaping (String) -> Void)
    {
        
        print("----------\(parameters)-------")
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "apikey": "ALDZ5abmAnppumwtjIdMBQU1SqHgL12G"
        ]
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                
                if let networkError = response.error {
                    if (networkError._code == -1009)
                    {
                        failure("NoInternet")
                        return
                    }
                }
                print("----------\(response.request!)----------")
                
                if let temp = response.response {
                    print("Getting response from Servdr !!", temp)
                    
                } else {
                    if (response.result.error as? AFError) != nil {
                        failure("UnableServer")
                    }
                    print("Couldn't get Response from Server !!")
                    failure("UnableServer")
                }
                if response.result.isSuccess {
                    let resJson = JSON(response.result.value!)
                    if !resJson.isEmpty {
                        sucess(resJson)
                    } else {
                        failure("UnableServer")
                    }
                }
                if response.result.isFailure {
                    failure("UnableServer")
                }
        }
    }
}
