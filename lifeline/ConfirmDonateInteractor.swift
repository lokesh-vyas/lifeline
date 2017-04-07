//
//  ConfirmDonateInteractor.swift
//  lifeline
//
//  Created by Apple on 03/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ConfirmDonateProtocol {
    func didSuccessGetCompaignDetails(jsonArray : JSON)
    func didFailGetCompaignDetails(Response:String)
}

protocol getVolunteerProtocol {
    func didSuccessGetVolunteerDetails(jsonArray : JSON)
    func didFailGetVolunteerDetails(Response:String)
}

class ConfirmDonateInteractor {
    
    static let sharedInstance : ConfirmDonateInteractor = {
        let instance = ConfirmDonateInteractor()
        return instance
    }()
    var delegate:ConfirmDonateProtocol?
    var delegateV:getVolunteerProtocol?
    
    //MARK:- Get Volunteer Details
    func getCompaignDetails(urlString : String, params : Dictionary<String,Any>) {
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            self.delegate?.didSuccessGetCompaignDetails(jsonArray: JSONResponse)
        },
                                                         failure: { (Response) -> Void in                                                            self.delegate?.didFailGetCompaignDetails(Response:Response)
        }
        )
    }
    
    //MARK:- Get Volunteer Details
    func getVolunteerDetails(urlString : String, params : Dictionary<String,Any>) {
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            self.delegateV?.didSuccessGetVolunteerDetails(jsonArray: JSONResponse)
        },
                                                         failure: {(Response) -> Void in
                                                            
                                                            self.delegateV?.didFailGetVolunteerDetails(Response:Response)
        })
    }
}

