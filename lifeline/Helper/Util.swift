//
//  Util.swift
//  lifeline
//
//  Created by iSteer on 12/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import Foundation


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

extension UIDatePicker
{
   @discardableResult func dateForServer(date:String) -> String
    {
        let dateFormatter = DateFormatter()
        let strtodate = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToStr = dateFormatter.string(from: strtodate)
        return dateToStr
    }
 
}
