//
//  RequestCommuntiyModel.swift
//  lifeline
//
//  Created by Anjali on 02/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol requestCommunityProtocol {
    func didSuccess(StatusCode: Int)
    func didfail(Response: String)
}

class RequestCommunityModel {
    var Name: String?
    var commmunityId: Int?
    var phone: String?
}
class RequestCommunityViewModel {
    static var SharedInstance: RequestCommunityViewModel {
        struct Shared {
            static let Instance = RequestCommunityViewModel()
        }
        return Shared.Instance
    }
    var delegate: requestCommunityProtocol?
    
    //MARK:- RequestCommunityServerCall
    func RequestCommunity(name:String, communityId:Int, loginId: String) {
        let reqBody : Dictionary =  ["Name" : name,"LoginId" : loginId,"CommunityId": communityId] as [String : Any]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_REQUEST_COMMUNITY.rawValue, method: "POST", parameters: reqBody, sucess: { (JSONResponse) -> Void in
            if(JSONResponse["RequestCommunity"]["StatusCode"].int == 0) {
                self.delegate?.didSuccess(StatusCode: 0)
            } else if(JSONResponse["RequestCommunity"]["StatusCode"].int == 1){
                self.delegate?.didSuccess(StatusCode: 1)
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didfail(Response: Response)
        })
    }
}
