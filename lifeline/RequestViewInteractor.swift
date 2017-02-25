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
    
    func succesfullyBloodRequest(success: Bool)
    func failedBloodRequest()
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
        
            
//            let builder = APIBuilder.sharedInstance.requestBloodAPI(patientName: patientname, contactperson: contactperson, contactnumber: contactnumber, whatyouneed: whatyouneed, whenyouneed: whenyouneed, bloodgroup: bloodgroup, units: units, hospitalbloodbankname: hospitalbloodbankname, doctorname: doctorname, contactnumberhospitalbloodbankname: contactnumberhospitalbloodbankname, hospitaladdress: hospitaladdress, landmark: landmark, city: city, pinCode: pinCode, appeal: appeal)
        
        
    let builder = APIBuilder.sharedInstance.buildBloodRequestApi(LoginID: LoginId, BloodGroup: bloodgroup, WhatYouNedd: whatyouneed, WhenYouNedd: whenyouneed, Units: Units, PatientName: patientname, ContactPerson: contactnumber, ContactNumber: contactnumber, DoctorName: doctorname, DoctorContact: doctorcontactnumber, DoctorEmailID: doctoremailID,centerID:centerID , CenterName: centername, CenterContactNumber: centercontactnumber, CenterAddress: centeraddress, City: City, State: State, Landmark: Landmark, Latitude: Latitude, Longitude: Longitude, Pincode: Pincode, country: Country, PersonalAppeal: personalappeal, SharedInSocialMedia: Sharedinsocialmedia)
        
        
            NetworkManager.sharedInstance.serviceCallForPOST(url: builder.URL, method: builder.method, parameters: builder.makeParams(),sucess:
                {
                    (JSONResponse) -> Void in
                    print(JSONResponse)
                    if(JSONResponse["BloodRequirementRequest"]["BloodRequirementDetails"]["StatusCode"].int == 0)
                    {
                        self.delegateRequestBlood?.succesfullyBloodRequest(success: true)
                    }else
                    {
                        self.delegateRequestBlood?.succesfullyBloodRequest(success: false)
                    }
            }, failure:
                { _ in
                    self.delegateRequestBlood?.failedBloodRequest()
            })
            
        }
    }

