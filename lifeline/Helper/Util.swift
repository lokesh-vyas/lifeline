//
//  Util.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation
import UIKit

class Util
{
    static let SharedInstance : Util = {
        let instance = Util()
        return instance
    }()
    //MARK:- Date Change Profile For Sever
    func dateChangeForServerForProfile(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dateObj!)
    }
    //MARK:- Current Date For Server
    func currentDateChangeForServer() -> String
    {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        return dateFormatter.string(from: date as Date)
    }
    //MARK:- Date Change For Sever
    func dateChangeForServer(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:sss+zzzz"
  
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: dateObj!)
    }
    //MARK:- date Chenge for DateofBirth for Profile
    func dateChangeForGetProfileDOB(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd+HH:mm"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringFromDate = dateFormatter.string(from: date!)
        return stringFromDate
    }
    //MARK:- date Chenge for server
    func dateChangeForInternal(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringFromDate = dateFormatter.string(from: date!)
        return stringFromDate
    }
    
    //MARK:-  Date For Camp
    func preferredDateToCamp(selectedDate : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = dateFormatter.date(from: selectedDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone!
        let stringFromDate = dateFormatter.string(from: date!)
        return stringFromDate
    }
    
    //MARK:- date selected by user
    func dateChangeForUser(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ" //2017-03-10T03:41:45.000+00:00
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        return dateFormatter.string(from: dateObj!)
    }
    
    //MARK:- Showing to User
    func showingDateToUser(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: dateObj!)
    }
    
    //MARK:- DateString to Date, with time [for notifiction]
    func dateStringToDateForNotification(dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone!
        let date = dateFormatter.date(from: dateString)
        return date!
    }

    //MARK:- Calculate Age
    func calcAge(birthday:String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
        let age = calcAge.year
        return String(describing: age!)
    }
    
    //MARK:- Date for reminding donation
    func dateForReminder(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone!
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let stringFromDate = dateFormatter.string(from: date!)
        return stringFromDate
    }
    
    //MARK:- Color Chenge From Hex String
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- searchBar Title
    func setSearchButtonText(text:String,searchBar:UISearchBar) {
        for subview in searchBar.subviews {
            for innerSubViews in subview.subviews {
                if let cancelButton = innerSubViews as? UIButton {
                   // cancelButton.setTitleColor(UIColor.white, for: .normal)
                    cancelButton.setTitle(text, for: .normal)
                }
            }
        }
        
    }
    //MARK:- Date Change From Date /To Date For Sever
    func dateChangeForFromDateInCamp(dateString:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.string(from: dateObj!)
        
        return dateFormatter.date(from: strDate)!
    }
}

//MARK:- Valid Mail ID
extension String
{
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    func isValidSpecialCharacter() -> Bool
    {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789.-()")
        if (self).rangeOfCharacter(from: characterset.inverted) != nil {
            return false
        }else
        {
            return true
        }
  }
}
//MARK:- Navigtion bar transperent
extension UINavigationController {
    
    func completelyTransparentBar()
    {
        navigationBar.setBackgroundImage(UIImage(), for:  .default)
        navigationBar.shadowImage     = UIImage()
        navigationBar.isTranslucent   = true
        view.backgroundColor          = UIColor.black.withAlphaComponent(0.2)
        navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor))
        {
            statusBar.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
    }
    func completelyTransparentBarForDonate()
    {
        navigationBar.setBackgroundImage(UIImage(), for:  .default)
        navigationBar.shadowImage     = UIImage()
        navigationBar.isTranslucent   = true
        view.backgroundColor          = UIColor.black.withAlphaComponent(0.8)
        navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor))
        {
            statusBar.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
    }

}
//MARK:- Padding of textfield
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
//MARK:- Corner Radius for View
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
// MARK:- Geadient Color
extension UIView {
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}

extension UIColor
{
    public class var myRedColor: UIColor
    {
        return UIColor(red: 182.0, green: 11.0, blue: 22.0, alpha: 1.0)
    }
    
    public class var myGreenColor: UIColor
    {
        return UIColor(red: 53.0, green: 206.0, blue: 17.0, alpha: 1.0)

    }
    
    public class var myBrownColor: UIColor
    {
        return UIColor(red: 128.0, green: 64.0, blue: 0.0, alpha: 1.0)
    }
    
}
