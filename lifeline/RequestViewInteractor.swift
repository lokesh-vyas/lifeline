//
//  RequestViewInteractor.swift
//  lifeline
//
//  Created by AppleMacBook on 24/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ProtocolRequestView {
    
    func succesfullyBloodRequest(success: Bool,message:String)
    func failedBloodRequest(Response:String)
}
//MARK:- ProfileView Model
class RequestViewModel
{
    static let SharedInstance : RequestViewModel = {
        let instance = RequestViewModel()
        return instance
    }()
    
    var isContactNumber:Bool?
    var isHospitalContactNumber:Bool?
    var isPin:Bool?

    var WhatYouNeed:String? = nil
    var WhenYouNeed:String? = nil
    var BloodGroup:String? = nil
    var BloodUnit:String? = nil
    var Latitude:String?
    var Longitude:String?
    var CentreID:String = ""
}
class RequestInterator
{
    class var SharedInstance : RequestInterator {
        struct Shared {
            static let Instance = RequestInterator()
        }
        return Shared.Instance
    }
    
    var delegateRequestBlood:ProtocolRequestView?
    
    func requesBlood(LoginId: String, bloodgroup : String, whatyouneed: String, whenyouneed: String, Units: String, patientname:String, contactperson: String, contactnumber: String, doctorname: String, doctorcontactnumber:String, doctoremailID:String,centerID:String,centername:String,centercontactnumber:String,centeraddress:String,City:String,State:String,Landmark:String,Latitude:String,Longitude:String,Pincode:String,Country:String,personalappeal:String,Sharedinsocialmedia:String)
    {
        
    let builder = APIBuilder.sharedInstance.buildBloodRequestApi(LoginID: LoginId, BloodGroup: bloodgroup, WhatYouNedd: whatyouneed, WhenYouNedd: whenyouneed, Units: Units, PatientName: patientname, ContactPerson: contactnumber, ContactNumber: contactnumber, DoctorName: doctorname, DoctorContact: doctorcontactnumber, DoctorEmailID: doctoremailID,centerID:centerID , CenterName: centername, CenterContactNumber: centercontactnumber, CenterAddress: centeraddress, City: City, State: State, Landmark: Landmark, Latitude: Latitude, Longitude: Longitude, Pincode: Pincode, country: Country, PersonalAppeal: personalappeal, SharedInSocialMedia: Sharedinsocialmedia)
        
        
            NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
                {
                    (JSONResponse) -> Void in
                    print(JSONResponse)
                    if(JSONResponse["BloodRequirementResponse"]["ResponseDetails"]["StatusCode"].int == 0)
                    {
                        self.delegateRequestBlood?.succesfullyBloodRequest(success: true,message: JSONResponse["BloodRequirementResponse"]["ResponseDetails"]["StatusMessage"].string!)
                    }else if(JSONResponse["BloodRequirementResponse"]["ResponseDetails"]["StatusCode"].int == 1)
                    {
                        self.delegateRequestBlood?.succesfullyBloodRequest(success: false,message: JSONResponse["BloodRequirementResponse"]["ResponseDetails"]["StatusMessage"].string!)
                    }
            }, failure:
                { (Response) -> Void in
                    self.delegateRequestBlood?.failedBloodRequest(Response:Response)
            })
            
        }
}
