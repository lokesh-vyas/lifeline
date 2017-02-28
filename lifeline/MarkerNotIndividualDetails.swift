//
//  MarkerNotIndividualDetails.swift
//  lifeline
//
//  Created by Apple on 26/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit


class MarkerNotIndividualDetails: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var viewMarkerDetails: UIView!
    
    var markerDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = markerDict["Name"] as! String?
        lblTiming.text = markerDict["WorkingHours"] as! String?
    }

    @IBAction func btnDonateTapped(_ sender: Any) {
        
    }
    
}

extension MarkerNotIndividualDetails : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: viewMarkerDetails))! {
            return true
        }
        dismiss(animated: true, completion: nil)
        return false
    }
}
