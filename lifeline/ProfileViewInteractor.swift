//
//  ProfileViewInteractor.swift
//  lifeline
//
//  Created by iSteer on 22/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

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
}
