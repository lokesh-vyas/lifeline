//
//  HudBar.swift
//  lifeline
//
//  Created by iSteer on 10/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import APESuperHUD

class HudBar
{
    func showHudWithTitleAndMessage(message:String,view:UIView)
    {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: "Facebook login", presentingView: view)
    }
}
