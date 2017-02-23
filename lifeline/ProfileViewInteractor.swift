//
//  ProfileViewInteractor.swift
//  lifeline
//
//  Created by iSteer on 22/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

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
