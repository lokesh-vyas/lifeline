//
//  APIBuilder.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

class APIBuilder
{
    static let sharedInstance : APIBuilder =
        {
            let instance = APIBuilder()
            return instance
    }()

    //MARK:- buildSignUpApi
    func buildSignUpApi(emailID: String, Password: String,UserName: String,Name:String) -> SignUpApi
    {
        let api = SignUpApi(email: emailID, password: Password, userID: UserName, name: Name)
        
        return api
    }
    //MARK:- Hospital List View API
    func buildHospitalListView(searchString:String) -> HospitalListApi {
        let api = HospitalListApi(SearchStr: searchString)
        return api
    }
    //MARK:- buildCheck Avaibility
    func buildGetProfileData(userID:String) -> GetProfileData
    {
        let api = GetProfileData(UserID: userID)
        return api
    }
    //MARK:- buildCheck Avaibility
    func buildCheckAvaibility(userID:String) -> CheckAvabilityApi
    {
        let api = CheckAvabilityApi(UserID: userID)
        return api
    }
    //MARK:- buildCheck Forget Password
    func buildForgetPasswordApi(userID:String) -> ForgetPasswordApi
    {
        let api = ForgetPasswordApi(UserID: userID)
        return api
    }
    //MARK:- buildLoginApi
    func buildLoginApi(Password: String, UserName: String) -> CustomLoginApi
    {
        let api = CustomLoginApi(userID: UserName, password: Password)
        return api
    }
    //MARK:- buildCheck Avaibility
    func buildMyRequestDeatils(LoginID:String) -> MyRequestApi
    {
        let api = MyRequestApi(LoginID: LoginID)
        return api
    }
    
    //MARK:- buildRequestBloodAPI
    func buildBloodRequestApi(LoginID:String, BloodGroup:String, WhatYouNedd:String,WhenYouNedd:String, Units:String, PatientName:String , ContactPerson:String, ContactNumber:String, DoctorName: String, DoctorContact: String, DoctorEmailID: String,centerID:String, CenterName: String, CenterContactNumber: String, CenterAddress: String, City:String, State:String, Landmark: String, Latitude: String, Longitude:String,Pincode: String, country:String, PersonalAppeal: String, SharedInSocialMedia: String) -> RequestApi
    {
        let requestApi = RequestApi(LoginId: LoginID, bloodgroup: BloodGroup, whatyouneed: WhatYouNedd, whenyouneed: WhenYouNedd, Units: Units, patientname: PatientName, contactperson: ContactPerson, contactnumber: ContactNumber, doctorname: DoctorName, doctorcontactnumber: DoctorContact, doctoremailID: DoctorEmailID,centerID:centerID,centername: CenterName, centercontactnumber: CenterContactNumber, centeraddress: CenterAddress, City: City, State: State, Landmark: Landmark, Latitude: Latitude, Longitude: Longitude, Pincode: Pincode, Country: country, personalappeal: PersonalAppeal, Sharedinsocialmedia: SharedInSocialMedia)
    
        return requestApi
}

}


    
