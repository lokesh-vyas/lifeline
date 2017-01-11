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
    //SingleTon Object
    static let sharedInstance : HudBar =
    {
        let instance = HudBar()
        return instance
    }()
    
    func showHudWithMessage(message:String,view:UIView)
    {
        APESuperHUD.showOrUpdateHUD(loadingIndicator: .standard, message: message, presentingView: view)
    }
    func showHudWithCustomImagesAndMessage(message:String,imageName:String,view:UIView)
    {
    
        APESuperHUD.showOrUpdateHUD(icon: UIImage(named: imageName)!, message: message, duration: 3.0, presentingView: view, completion:
        { _ in
            
        })
    }
    func showHudWithLifeLineIconAndMessage(message:String,view:UIView)
    {
        APESuperHUD.showOrUpdateHUD(icon: UIImage(named: "LifeLine_icon.png")!, message: message, duration: 3.0, presentingView: view, completion:
            { _ in
                
        })
    }
    func showHudWithTitleAndMessage(title:String,message:String,view:UIView)
    {
        APESuperHUD.showOrUpdateHUD(title: title, message: message, presentingView: view)
        { _ in
        }
    }
    func hideHudFormView(view:UIView)
    {
         
        APESuperHUD.removeHUD(animated: true, presentingView: view, completion:
        { _ in
        })
    }
    func customUI()
    {
        APESuperHUD.appearance.cornerRadius = 12
        APESuperHUD.appearance.animateInTime = 1.0
        APESuperHUD.appearance.animateOutTime = 1.0
        APESuperHUD.appearance.backgroundBlurEffect = .none
        APESuperHUD.appearance.iconColor = UIColor.green
        APESuperHUD.appearance.textColor =  UIColor.green
        APESuperHUD.appearance.loadingActivityIndicatorColor = UIColor.green
        APESuperHUD.appearance.defaultDurationTime = 4.0
        APESuperHUD.appearance.cancelableOnTouch = true
        APESuperHUD.appearance.iconWidth = 48
        APESuperHUD.appearance.iconHeight = 48
        APESuperHUD.appearance.messageFontName = "Caviar Dreams"
        APESuperHUD.appearance.titleFontName = "Caviar Dreams"
        APESuperHUD.appearance.titleFontSize = 22
        APESuperHUD.appearance.messageFontSize = 14
    }
}
