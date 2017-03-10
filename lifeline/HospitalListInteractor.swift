//
//  HospitalListInteractor.swift
//  lifeline
//
//  Created by iSteer on 16/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol HospitalListProtocol
{
    func SuccessHospitalListProtocol(jsonArray:JSON)
    func FailedHospitalListProtocol()
}
class HospitalListModel
{
 
    var CentreID:String = ""
    var HospitalName:String? = nil
    var HospitalContactNumber:Int? = nil
    var AddressLine:String? = nil
    var City:String? = nil
    var PINCode:String? = nil
    var State:String? = nil
    var Contry:String? = nil
    var Landmark:String? = nil
    var Latitude:String? = nil
    var Longitude:String? = nil
}
class HospitalListInteractor
{
    class var SharedInstance: HospitalListInteractor {
        struct Shared {
            static let Instance = HospitalListInteractor()
        }
        return Shared.Instance
    }
    
    var delegate:HospitalListProtocol?
    
    func HospitalSearchByString(searchString:String)
    {
        let builder = APIBuilder.sharedInstance.buildHospitalListView(searchString: searchString)
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(), sucess:
        {
            (JSONResponse) -> Void in
            self.delegate?.SuccessHospitalListProtocol(jsonArray: JSONResponse)
            
        }, failure: {_  in
            self.delegate?.FailedHospitalListProtocol()
        })
    }
}
