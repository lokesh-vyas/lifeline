//
//  RequestApi.swift
//  lifeline
//
//  Created by AppleMacBook on 22/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import Alamofire


class RequestApi
{
    var LoginId = "114177301473189791455"
    var bloodGroup = ""
    var whatYouNeed = ""
    var whenYouNeed = ""
    var units = ""
    var patientName = ""
    var contactPerson = ""
    var contactNumber = ""
    var doctorName = ""
    var DoctorContact = ""
    var DoctorEmailID = ""
    var hospitalbloodbankname = ""
    var hospitalbloodbankID = ""
    var contactNumberHospitalbloodbankname = ""
    var hospitalAddress = ""
    var city = ""
    var state = ""
    var landMark = ""
    var latitude = ""
    var longitude = ""
    var pinCode = ""
    var country = ""
    var PersonalAppeal = ""
    var SharedInSocialMedia = ""
    
    var URL = URLList.BLOOD_REQUIREMENT.rawValue
    var method = "POST"
    
    
    init(LoginId: String, bloodgroup : String, whatyouneed: String, whenyouneed: String, Units: String, patientname:String, contactperson: String, contactnumber: String, doctorname: String, doctorcontactnumber:String, doctoremailID:String,centerID:String,centername:String,centercontactnumber:String,centeraddress:String,City:String,State:String,Landmark:String,Latitude:String,Longitude:String,Pincode:String,Country:String,personalappeal:String,Sharedinsocialmedia:String)
    {
        
        self.LoginId = LoginId
        self.bloodGroup = bloodgroup
        self.whatYouNeed = whatyouneed
        self.whenYouNeed = whenyouneed
        self.units = Units
        self.patientName = patientname
        self.contactPerson = contactperson
        self.contactNumber = contactnumber
        self.doctorName = doctorname
        self.DoctorContact = doctorcontactnumber
        self.DoctorEmailID = doctoremailID
        self.hospitalbloodbankID = centerID
        self.hospitalbloodbankname = centername
        self.contactNumberHospitalbloodbankname = centercontactnumber
        self.hospitalAddress = centeraddress
        self.city = City
        self.state = State
        self.landMark = Landmark
        self.latitude = Latitude
        self.longitude = Longitude
        self.pinCode = Pincode
        self.country = Country
        self.PersonalAppeal = personalappeal
        self.SharedInSocialMedia = Sharedinsocialmedia
    }
    
    func makeParams() -> Parameters
    {
        let parameters:Parameters = ["BloodRequirementRequest":["BloodRequirementDetails":[["LoginID":self.LoginId],["BloodGroup": self.bloodGroup],["DonationType":self.whatYouNeed],["WhenNeeded":self.whenYouNeed],["NumUnits":self.units],["PatientName":self.patientName],["ContactPerson":self.contactPerson],["ContactNumber":self.contactNumber],["DoctorName":self.doctorName],["DoctorContact":self.DoctorContact],["DoctorEmailID":self.DoctorEmailID],["CenterID":self.hospitalbloodbankID],["CollectionCentreName":hospitalbloodbankname],["CenterContactNo":self.contactNumberHospitalbloodbankname],["AddressLine":self.hospitalAddress],["City":self.city],["State":self.state],["LandMark":self.landMark],["Latitude":self.latitude],["Longitude":self.longitude],["PINCode":self.pinCode],["Country":self.country],["PersonalAppeal":self.PersonalAppeal],["SharedInSocialMedia":self.SharedInSocialMedia]]]]
        
        return parameters
    }
    
    
}
