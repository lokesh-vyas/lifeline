//
//  UpdateViewModel.swift
//  lifeline
//
//  Created by Anjali on 07/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol updateProtocol {
    func didSuccess()
    func didFail(Response: String)
}
class UpdateViewModel {
    static var SharedInstance: UpdateViewModel {
        struct Shared {
            static let Instance = UpdateViewModel()
        }
        return Shared.Instance
    }
    var delegate : updateProtocol?
    
    //MARK:- UpdateCommunityServerCall
    func updateCommunity(name: String, description: String, type: String, phone: String, logo: String, contactName: String,communityId: Int) {
        let reqBody : Dictionary =  ["UpdateCommunity":["Name" : name,"Description": description,"Type": type,"Phone": phone,"Logo": logo,"LoginId" : "\(UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!)","ContactName": contactName, "CommunityId": communityId]]
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_UPDATE_COMMUNITY.rawValue, method: "POST", parameters: reqBody, sucess: {(JSONResponse) -> Void in
            if(JSONResponse["UpdateCommunity"]["StatusCode"].int == 0) {
                self.delegate?.didSuccess()
            }
        }, failure: { (Response) -> Void in
            print("Here in failure....")
            self.delegate?.didFail(Response: Response)
        })
    }
}
