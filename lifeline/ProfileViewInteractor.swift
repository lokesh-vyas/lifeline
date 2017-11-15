//
//  ProfileViewInteractor.swift
//  lifeline
//
//  Created by iSteer on 22/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK:- ProtocolGetProfile
protocol ProtocolGetProfile {
    func succesfullyGetProfile(success: Bool)
    func failedGetProfile(success: Bool)
}
//MARK:- ProtocolRegisterProfile
protocol ProtocolRegisterProfile {
    func succesfullyRegisterProfile(success: Bool)
    func failedRegisterProfile(Response:String)
}
//MARK:- ProfileView Model
class ProfileViewModel
{
    class var SharedInstance : ProfileViewModel
    {
        struct Shared {
            static let instance = ProfileViewModel()
        }
        return Shared.instance
    }
    
    var isEmail:Bool?
    var isContactNumber:Bool?
    var isHomePin:Bool?
    var isWorkPin:Bool?
    var DOBstring:String?
    var LastDonationStrin:String?
    var BloodGroup:String?
    var homeLat:String = ""
    var homeLong:String = ""
    var workLat:String = ""
    var workLong:String = ""
}

//MARK:- ProfileView Interactor
class ProfileViewInteractor
{
    class var SharedInstance : ProfileViewInteractor
    {
        struct Shared {
            static let instance = ProfileViewInteractor()
        }
        return Shared.instance
    }
    var delegate:ProtocolGetProfile?
    var delegateProfile:ProtocolRegisterProfile?
    //MARK:- checkGetProfileData
    func checkGetProfileData(LoginID:String)
    {
        let builder = APIBuilder.sharedInstance.buildGetProfileData(userID: LoginID)
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: URLList.LIFELINE_Get_Profile.rawValue, method: builder.method, parameters: builder.makeParams(),sucess:
            {
                (JSONResponse) -> Void in
                if(JSONResponse["GetProfileResponse"]["GetProfileResponseDetails"]["StatusCode"].int == 0)
                {
                    let jsonDict = JSONResponse["GetProfileResponse"]["GetProfileResponseDetails"]
                    if jsonDict["RoleName"].string != nil
                    {
                        if (jsonDict["RoleName"].string == "BloodBank")
                        {
                            self.delegate?.failedGetProfile(success: true)
                            return
                        }
                    }
                    self.serverDataInProfileData(JSONResponse: JSONResponse)
                }
                else
                {
                    self.delegate?.succesfullyGetProfile(success: false)
                }
        }, failure:
            { _ in
                self.delegate?.failedGetProfile(success: false)
        })
    }
    //MARK:- MyProfileRegistration
    func MyProfileRegistration(params:Dictionary<String,Any>)
    {
        let urlString = URLList.PROFILE_REGISTRATION.rawValue
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            if (JSONResponse["ProfileRegistrationResponse"]["ProfileDetails"]["StatusCode"].int == 0)
                                                            {
                                                                self.delegateProfile?.succesfullyRegisterProfile(success: true)
                                                            }else
                                                            {
                                                                self.delegateProfile?.succesfullyRegisterProfile(success: false)
                                                            }
        },
                                                         failure: { (Response) -> Void in
                                                            self.delegateProfile?.failedRegisterProfile(Response:Response)
        }
        )
    }
    //MARK:- DeviceRegistration
    func MyDeviceRegistration(params:Dictionary<String,Any>)
    {
        let urlString = URLList.Device_Token_Reg.rawValue
        
        NetworkManager.sharedInstance.serviceCallForPOST(url: urlString,
                                                         method: "POST",
                                                         parameters: params,
                                                         sucess: {
                                                            (JSONResponse) -> Void in
                                                            if (JSONResponse["DeviceDetailsResponse"]["DeviceDetails"]["StatusCode"].int == 0)
                                                            {
                                                                self.delegateProfile?.succesfullyRegisterProfile(success: true)
                                                            }else
                                                            {
                                                                self.delegateProfile?.succesfullyRegisterProfile(success: false)
                                                            }
        },
                                                         failure: {  (Response) -> Void in
                                                            self.delegateProfile?.failedRegisterProfile(Response:Response)
        }
        )
    }
    //MARK:- server Data in profile
    func serverDataInProfileData(JSONResponse:JSON)
    {
        let jsonDict = JSONResponse["GetProfileResponse"]["GetProfileResponseDetails"]
        print("Profile All Data : \(jsonDict)")
        let contactNumber:String
        var age:String
        let HomeLatitude:String
        let HomeLongitude:String
        let WorkLatitude:String
        let WorkLongitude:String
        let HomePinCode:String
        let WorkPinCode:String
        let HomeAdressLine:String
        let WorkAddressLine:String
        let HomeAdressCity:String
        let WorkAddressCity:String
        let DateOfBirth:String
        let LastDonationDate:String
        let name:String = jsonDict["Name"].string!
        let emailID:String = jsonDict["EmailId"].string!
        let BloodGroup:String = jsonDict["BloodGroup"].string!
       
        if jsonDict["Age"].string != nil
        {
            age = jsonDict["Age"].string!
            //FIXME:- Age
        }
        else
        {
            age = String(describing: jsonDict["Age"])
        }
        if jsonDict["ContactNumber"].string != nil
        {
            contactNumber = jsonDict["ContactNumber"].string!
        }
        else
        {
            contactNumber = String(describing: jsonDict["ContactNumber"])
        }
        if jsonDict["AddressIDHome"] != 0
        {
            let AddressHome = jsonDict["AddressHomeDetails"]
            if AddressHome["City"].string != nil
            {
                HomeAdressCity = AddressHome["City"].string!
            }
            else
            {
                HomeAdressCity = ""
            }
            
            if AddressHome["AddressLine"].string != nil
            {
                HomeAdressLine = AddressHome["AddressLine"].string!
            }
            else
            {
                HomeAdressLine = ""
            }
            
            if AddressHome["PINCode"].string != nil
            {
                if AddressHome["PINCode"].string != nil
                {
                    HomePinCode = AddressHome["PINCode"].string!
                }
                else
                {
                    HomePinCode = String(describing: AddressHome["PINCode"])
                }
            }else
            {
                HomePinCode = ""
            }
            
            if AddressHome["Latitude"].string != nil
            {
                if AddressHome["Latitude"].string != nil
                {
                    HomeLatitude = AddressHome["Latitude"].string!
                }
                else
                {
                    HomeLatitude = String(describing: AddressHome["Latitude"])
                }
            }else
            {
                HomeLatitude = ""
            }
            
            if AddressHome["Longitude"].string != nil
            {
                if AddressHome["Longitude"].string != nil
                {
                    HomeLongitude = AddressHome["Longitude"].string!
                }
                else
                {
                    HomeLongitude = String(describing: AddressHome["Longitude"])
                }
            }else
            {
                HomeLongitude = ""
            }
        }
        else
        {
            HomePinCode = ""
            HomeLatitude = ""
            HomeLongitude = ""
            HomeAdressCity = ""
            HomeAdressLine = ""
        }
        
        if jsonDict["AddressIDWork"] != 0
        {
            let AddressHome = jsonDict["AddressWorkDetails"]
            if AddressHome["City"].string != nil
            {
                WorkAddressCity = AddressHome["City"].string!
            }
            else
            {
                WorkAddressCity = ""
            }
            
            if AddressHome["AddressLine"].string != nil
            {
                WorkAddressLine = AddressHome["AddressLine"].string!
            }
            else
            {
                WorkAddressLine = ""
            }
            
            if AddressHome["PINCode"].string != nil
            {
                if AddressHome["PINCode"].string != nil
                {
                    WorkPinCode = AddressHome["PINCode"].string!
                }
                else
                {
                    WorkPinCode = String(describing: AddressHome["PINCode"])
                }
            }else
            {
                WorkPinCode = ""
            }
            
            if AddressHome["Latitude"].string != nil
            {
                if AddressHome["Latitude"].string != nil
                {
                    WorkLatitude = AddressHome["Latitude"].string!
                }
                else
                {
                    WorkLatitude = String(describing: AddressHome["Latitude"])
                }
            }else
            {
                WorkLatitude = ""
            }
            
            if AddressHome["Longitude"].string != nil
            {
                if AddressHome["Longitude"].string != nil
                {
                    WorkLongitude = AddressHome["Longitude"].string!
                }
                else
                {
                    WorkLongitude = String(describing: AddressHome["Longitude"])
                }
            }else
            {
                WorkLongitude = ""
            }
        }
        else
        {
            WorkPinCode = ""
            WorkLatitude = ""
            WorkLongitude = ""
            WorkAddressLine = ""
            WorkAddressCity = ""
        }
        
        if jsonDict["DateofBirth"].string != nil
        {
            DateOfBirth = Util.SharedInstance.dateChangeForGetProfileDOB(dateString: jsonDict["DateofBirth"].string!)
            age = Util.SharedInstance.calcAge(birthday: DateOfBirth)
        }
        else
        {
            DateOfBirth = ""
        }
        
        if jsonDict["LastDonatedOn"].string != nil
        {
            LastDonationDate = Util.SharedInstance.dateChangeForGetProfileDOB(dateString: jsonDict["LastDonatedOn"].string!)
        }
        else
        {
            LastDonationDate = ""
        }
        
        let profileData = ProfileData(Name: name, EmailID: emailID, ContactNumber: contactNumber, DateOfBirth: DateOfBirth, Age: age, BloodGroup: BloodGroup, LastDonationDate: LastDonationDate, HomeAddressLine: HomeAdressLine, HomeAddressCity: HomeAdressCity, HomeAddressPINCode: HomePinCode, HomeAddressLatitude: HomeLatitude, HomeAddressLongitude: HomeLongitude, WorkAddressLine: WorkAddressLine, WorkAddressCity: WorkAddressCity, WorkAddressPINCode: WorkPinCode, WorkAddressLatitude: WorkLatitude, WorkAddressLongitude: WorkLongitude)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: profileData)
        UserDefaults.standard.set(data, forKey: "ProfileData")
        
        self.delegate?.succesfullyGetProfile(success: true)
    }
}
