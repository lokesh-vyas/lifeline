//
//  IndividualConfirmDonateInteractor.swift
//  lifeline
//
//  Created by Apple on 03/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol IndividualRequestDetailsProtocol {
    func didSuccessGetRequestDetails(jsonArray : JSON)
    func didFailGetRequestDetails()
}

class IndividualConfirmDonateInteractor {
    static let sharedInstance : IndividualConfirmDonateInteractor = {
        let instance = IndividualConfirmDonateInteractor()
        return instance
    }()
    var delegate:IndividualRequestDetailsProtocol?
    func getRequestDetails(urlString : String, params : Dictionary<String,Any>) {
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            self.delegate?.didSuccessGetRequestDetails(jsonArray: JSONResponse)
        },
                                                         failure: { _ in
                                                            self.delegate?.didFailGetRequestDetails()
        }
        )
    }
}

