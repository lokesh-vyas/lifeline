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

    @IBOutlet weak var viewCloseRequest: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view.
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
