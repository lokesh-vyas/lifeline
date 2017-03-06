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
    var markerDict = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markerDict = MarkerData.SharedInstance.markerData
        lblName.text = markerDict["Name"] as! String?
        
        lblTiming.text = markerDict["WorkingHours"] as! String?
    }
    @IBAction func btnDonateTapped(_ sender: Any) {
        let cnfDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
        let navigationControllerStack = UINavigationController(rootViewController: cnfDonate)
        self.present(navigationControllerStack, animated: true, completion: nil)
        
    }

    @IBAction func btnToViewTapped(_ sender: Any) {
//        let requestedTable = self.storyboard?.instantiateViewController(withIdentifier: "RequestedByIndividuals") as! RequestedByIndividuals
//        self.present(requestedTable, animated: true, completion: nil)

        
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
