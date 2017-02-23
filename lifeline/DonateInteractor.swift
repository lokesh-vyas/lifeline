//
//  DonateInteractor.swift
//  lifeline
//
//  Created by Apple on 18/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DonateViewProtocol {
    func successDonateSources(jsonArray : JSON)
    func failedDonateSources()
}

class DonateInteractor {
    static let sharedInstance : DonateInteractor = {
        let instance = DonateInteractor()
        return instance
    }()
    var delegate:DonateViewProtocol?
    func findingDonateSources(urlString : String, params : Dictionary<String,Any>) {
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                                    (JSONResponse) -> Void in
                                                        self.delegate?.successDonateSources(jsonArray: JSONResponse)
                                                                    },
                                                          failure: { _ in
                                                        self.delegate?.failedDonateSources()
                                                                  }
        )
    }
}
