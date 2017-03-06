//
//  MarkerData.swift
//  lifeline
//
//  Created by Apple on 01/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

class MarkerData {
    
    var markerData = [String : Any]()
    var IndividualsArray = [Dictionary<String, Any>]()
    var oneRequestOfDonate  = [String : Any]()
    
    class var SharedInstance : MarkerData {
        struct shared {
            static let instance = MarkerData()
        }
        return shared.instance
    }
}
