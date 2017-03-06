//
//  ProfileData.swift
//  lifeline
//
//  Created by iSteer on 04/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

class ProfileData: NSObject, NSCoding
{

    var Name: String
    var EmailId: String
    var ContactNumber: String
    var DateofBirth: String
    var Age: String
    var BloodGroup: String
    var LastDonatedOn: String

    var HomeAddressLine: String
    var HomeAddressCity: String
    var HomeAddressPINCode: String
    var HomeAddressLatitude: String
    var HomeAddressLongitude: String
    
    var WorkAddressLine: String
    var WorkAddressCity: String
    var WorkAddressPINCode: String
    var WorkAddressLatitude: String
    var WorkAddressLongitude: String

    // Memberwise initializer
    init(Name: String, EmailID: String, ContactNumber: String, DateOfBirth: String, Age: String, BloodGroup:String, LastDonationDate:String, HomeAddressLine:String, HomeAddressCity:String, HomeAddressPINCode:String, HomeAddressLatitude:String, HomeAddressLongitude:String, WorkAddressLine:String, WorkAddressCity:String, WorkAddressPINCode:String, WorkAddressLatitude:String, WorkAddressLongitude:String) {
        self.Name = Name
        self.EmailId = EmailID
        self.ContactNumber = ContactNumber
        self.DateofBirth = DateOfBirth
        self.Age = Age
        self.BloodGroup = BloodGroup
        self.LastDonatedOn = LastDonationDate
        self.HomeAddressLine = HomeAddressLine
        self.HomeAddressCity = HomeAddressCity
        self.HomeAddressPINCode = HomeAddressPINCode
        self.HomeAddressLatitude = HomeAddressLatitude
        self.HomeAddressLongitude = HomeAddressLongitude
        self.WorkAddressLine = WorkAddressLine
        self.WorkAddressCity = WorkAddressCity
        self.WorkAddressPINCode = WorkAddressPINCode
        self.WorkAddressLatitude = WorkAddressLatitude
        self.WorkAddressLongitude = WorkAddressLongitude
       
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard
        let name = decoder.decodeObject(forKey: "name") as? String,
        let email = decoder.decodeObject(forKey: "email") as? String,
        let contactNumber = decoder.decodeObject(forKey: "contactNumber") as? String,
        let dateofbirth = decoder.decodeObject(forKey: "dateofbirth") as? String,
        let age = decoder.decodeObject(forKey: "age") as? String,
        let bloodGroup = decoder.decodeObject(forKey: "bloodGroup") as? String,
        
        let lastDontionOn = decoder.decodeObject(forKey: "lastDontionOn") as? String,
            
        let homeAddressCity = decoder.decodeObject(forKey: "homeAddressCity") as? String,
        let homeAddressPINCode = decoder.decodeObject(forKey: "homeAddressPINCode") as? String,
        let homeAddressLatitude = decoder.decodeObject(forKey: "homeAddressLatitude") as? String,
        let homeAddressLine = decoder.decodeObject(forKey: "homeAddressLine") as? String,
        let homeAddressLongitude = decoder.decodeObject(forKey: "homeAddressLongitude") as? String,
            
        let workAddressCity = decoder.decodeObject(forKey: "workAddressCity") as? String,
        let workAddressPINCode = decoder.decodeObject(forKey: "workAddressPINCode") as? String,
        let workAddressLatitude = decoder.decodeObject(forKey: "workAddressLatitude") as? String,
        let workAddressLine = decoder.decodeObject(forKey: "workAddressLine") as? String,
        let workAddressLongitude = decoder.decodeObject(forKey: "workAddressLongitude") as? String
            else { return nil }
        
        self.init(
            Name: name,
            EmailID: email,
            ContactNumber: contactNumber,
            DateOfBirth: dateofbirth,
            Age: age,
            BloodGroup: bloodGroup,
            LastDonationDate: lastDontionOn,
            HomeAddressLine: homeAddressLine,
            HomeAddressCity: homeAddressCity,
            HomeAddressPINCode: homeAddressPINCode,
            HomeAddressLatitude: homeAddressLatitude,
            HomeAddressLongitude: homeAddressLongitude,
            
            WorkAddressLine: workAddressLine,
            WorkAddressCity: workAddressCity,
            WorkAddressPINCode: workAddressPINCode,
            WorkAddressLatitude: workAddressLatitude,
            WorkAddressLongitude: workAddressLongitude
            )
    }
    
    func  encode(with coder: NSCoder) {
        coder.encode(self.Name, forKey: "name")
        coder.encode(self.EmailId, forKey: "email")
        coder.encode(self.ContactNumber, forKey: "contactNumber")
        coder.encode(self.DateofBirth, forKey: "dateofbirth")
        coder.encode(self.Age, forKey: "age")
        coder.encode(self.BloodGroup, forKey: "bloodGroup")
        coder.encode(self.LastDonatedOn, forKey: "lastDontionOn")
        coder.encode(self.HomeAddressCity, forKey: "homeAddressCity")
        coder.encode(self.HomeAddressPINCode, forKey: "homeAddressPINCode")
        coder.encode(self.HomeAddressLine, forKey: "homeAddressLine")
        coder.encode(self.HomeAddressLatitude, forKey: "homeAddressLatitude")
        coder.encode(self.HomeAddressLongitude, forKey: "homeAddressLongitude")
        
        coder.encode(self.WorkAddressCity, forKey: "workAddressCity")
        coder.encode(self.WorkAddressPINCode, forKey: "workAddressPINCode")
        coder.encode(self.WorkAddressLine, forKey: "workAddressLine")
        coder.encode(self.WorkAddressLatitude, forKey: "workAddressLatitude")
        coder.encode(self.WorkAddressLongitude, forKey: "workAddressLongitude")
       
    }
}
