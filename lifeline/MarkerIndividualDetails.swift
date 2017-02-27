//
//  MarkerIndividualDetails.swift
//  lifeline
//
//  Created by Apple on 26/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MarkerIndividualDetails: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var viewMarkerDetails: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnDonateTapped(_ sender: Any) {
    }

    @IBAction func btnToViewTapped(_ sender: Any) {
    }
   
}

extension MarkerIndividualDetails : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: viewMarkerDetails))! {
            return true
        }
        
        dismiss(animated: true, completion: nil)
        return false
    }
}
