//
//  AppleLanguagesGroup.swift
//  lifeline
//
//  Created by Apple on 06/06/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
/// Mulli-langugages
class MultiLanguage {  //is responsible for getting/setting language from/in the UserDefaults.
    
    /// get current Apple language
    
    class func currentAppleLanguage() -> String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
        return currentWithoutLocale
    }
    
    class func currentAppleLanguageFull() -> String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
    /// get Local Strings from using KEY
    class func getLanguageUsingKey(_ key:String)->String{
        var lagStr :String
        let profileSuccess = UserDefaults.standard.bool(forKey: "SuccessProfileRegistration")
        if profileSuccess == false
        {
            lagStr = currentAppleLanguage()
        }else
        {
            lagStr = currentAppleLanguageFull()
        }
        let path1 = Bundle.main.path(forResource: lagStr, ofType: "lproj")
        let bundle1 = Bundle(path: path1!)
        let string1 = bundle1?.localizedString(forKey: key, value: nil, table: nil)
    
        return string1!
    }
}
