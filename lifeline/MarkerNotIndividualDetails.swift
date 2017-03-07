//
//  MarkerNotIndividualDetails.swift
//  lifeline
//
//  Created by Apple on 26/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit



class MarkerNotIndividualDetails: UIViewController {

    @IBOutlet weak var lblHead: UILabel!
    
    @IBOutlet weak var btnDonate: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var viewMarkerDetails: UIView!
    @IBOutlet weak var lblToDate: UILabel!
    @IBOutlet weak var lblFromDate: UILabel!
    @IBOutlet weak var FromDate: UILabel!
    @IBOutlet weak var ToDate: UILabel!
    
    var markerDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME:- markerDict ?
        markerDict = MarkerData.SharedInstance.markerData
        lblName.text = markerDict["Name"] as! String?
        lblTiming.text = markerDict["WorkingHours"] as! String?
        
        
        if (markerDict["TypeOfOrg"] as! String?  == "2") { // i.e. Campaign
            
            //FIXME:- camp color #0dd670
            FromDate.isHidden = false
            ToDate.isHidden = false
            lblFromDate.isHidden = false
            lblToDate.isHidden = false
            lblFromDate.text = MarkerData.SharedInstance.markerData["FromDate"] as! String?
            lblToDate.text = MarkerData.SharedInstance.markerData["ToDate"] as! String?
            
            lblHead.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#0dd670")
            btnDonate.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#0dd670")
            viewMarkerDetails.layer.borderColor = Util.SharedInstance.hexStringToUIColor(hex: "#0dd670").cgColor

        } else {
            
            //FIXME:- Ho color #b6800b
            lblHead.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#b6800b")
            btnDonate.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#b6800b")
            viewMarkerDetails.layer.borderColor = Util.SharedInstance.hexStringToUIColor(hex: "#b6800b").cgColor
            
            FromDate.isHidden = true
            ToDate.isHidden = true
            lblFromDate.isHidden = true
            lblToDate.isHidden = true
            
        }
    }

    @IBAction func btnDonateTapped(_ sender: Any) {
        
        let cnfDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
        let navigationControllerStack = UINavigationController(rootViewController: cnfDonate)
        self.present(navigationControllerStack, animated: true, completion: nil)
       // self.navigationController?.pushViewController(navigationControllerStack, animated: true)


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
