//
//  MyRequestClose.swift
//  lifeline
//
//  Created by iSteer on 25/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyRequestClose: UIViewController {
    @IBOutlet var tapGestureForBack: UITapGestureRecognizer!

    @IBOutlet weak var viewCloseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCloseRequest: UIView!
    var closeRequestID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MyRequestClose.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyRequestClose.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            // Do any additional setup after loading the view.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- keyboard Appear / DisAppear
    func keyboardWillShow(notification: NSNotification) {
       
        UIView.animate(withDuration: Double(0.5), animations: {
            self.viewCloseTopConstraint.constant = -70
            self.view.layoutIfNeeded()
        })
    }
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.viewCloseTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK:- btnCancelTapped
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- btnSubmitTapped
    @IBAction func btnSubmitTapped(_ sender: Any) {
    }
}
extension MyRequestClose:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.viewCloseRequest))!
        {
            return false
        }
        self.dismiss(animated: true, completion: nil)
        return true
    }
}
