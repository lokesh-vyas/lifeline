//
//  AlertConfirmDonateInteractor.swift
//  lifeline
//
//  Created by Apple on 01/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol AlertConfirmDonateProtocol {
    func successConfirmDonate(jsonArray : JSON)
    func failedConfirmDonate(Response:String)
}

class AlertConfirmDonateInteractor {
    static let sharedInstance : AlertConfirmDonateInteractor = {
        let instance = AlertConfirmDonateInteractor()
        return instance
    }()
    var delegate:AlertConfirmDonateProtocol?
    func confirmsDonate(urlString : String, params : Dictionary<String,Any>) {
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            self.delegate?.successConfirmDonate(jsonArray: JSONResponse)
        },
                                                         failure: {(Response) -> Void in
                                                            
                                                            self.delegate?.failedConfirmDonate(Response:Response)
        }
        )
    }
}
