//
//  HospitalListApi.swift
//  lifeline
//
//  Created by iSteer on 16/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import Alamofire

class HospitalListApi {
    
    var searchString = ""
    var URL = URLList.GET_COLLECTION_CENTRE_LIST.rawValue
    var method = "POST"
    
    init(SearchStr:String)
    {
        self.searchString = SearchStr
    }
    
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["GetCollectionCentersList":["RequestDetails":["Name":self.searchString]]]
        return parameters
    }
}
