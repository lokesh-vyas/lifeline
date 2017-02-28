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
    func dateChangeForServer(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:sss+zzzz"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        return dateFormatter.string(from: dateObj!)
    }
    func dateChangeForInternal(dateString:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        return dateFormatter.string(from: dateObj!)
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
}

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
}
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
