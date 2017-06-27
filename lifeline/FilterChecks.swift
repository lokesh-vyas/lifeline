//
//  FilterChecks.swift
//  lifeline
//
//  Created by Apple on 24/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import CoreLocation

//protocol filterMarkersProtocol {
//    func didSuccessFilters(sender: FilterChecks)
//}

class SingleTon {
    
    var isCheckedIndividual = true
    var isCheckedHospital = true
    var isCheckedCamp = true
    var noMarkers : Bool?
    var cameFromMarkersList : Bool?
    var currentLatitude : CLLocationDegrees!
    var currentLongitude : CLLocationDegrees!
    
    
    class var SharedInstance : SingleTon {
        struct Shared {
            static let Instance = SingleTon()
        }
        return Shared.Instance
    }
}

class FilterChecks: UIViewController {

    @IBOutlet weak var btnCheckboxIndividual: UIButton!
    @IBOutlet weak var btnCheckboxHospital: UIButton!
    @IBOutlet weak var btnCheckboxCamp: UIButton!
    @IBOutlet weak var subViewFilter: UIView!
    
//    var delegate : filterMarkersProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        if !(SingleTon.SharedInstance.isCheckedIndividual) {
            btnCheckboxIndividual.setImage(UIImage(named : "Unchecked Checkbox-32.png"), for: .normal)
        }
        if !(SingleTon.SharedInstance.isCheckedHospital) {
            btnCheckboxHospital.setImage(UIImage(named : "Unchecked Checkbox-32.png"), for: .normal)
        }
        if !(SingleTon.SharedInstance.isCheckedCamp) {
            btnCheckboxCamp.setImage(UIImage(named : "Unchecked Checkbox-32.png"), for: .normal)
        }
    }
    @IBAction func btnCheckboxIndividualTapped(_ sender: Any) {
        
        if SingleTon.SharedInstance.isCheckedIndividual {
            btnCheckboxIndividual.setImage(UIImage(named : "Unchecked Checkbox-32.png"), for: .normal)
            SingleTon.SharedInstance.isCheckedIndividual = false
        } else {
            btnCheckboxIndividual.setImage(UIImage(named : "Checked Checkbox 2-32.png"), for: .normal)
            SingleTon.SharedInstance.isCheckedIndividual = true
        }
    }
    
    @IBAction func btnCheckboxHospitalTapped(_ sender: Any) {
        
        if SingleTon.SharedInstance.isCheckedHospital {
            btnCheckboxHospital.setImage(UIImage(named : "Unchecked Checkbox-32.png"), for: .normal)
            SingleTon.SharedInstance.isCheckedHospital = false
        } else {
            btnCheckboxHospital.setImage(UIImage(named : "Checked Checkbox 2-32.png"), for: .normal)
            SingleTon.SharedInstance.isCheckedHospital = true
        }
    }
    
    @IBAction func btnCheckboxCampTapped(_ sender: Any) {
        
        if SingleTon.SharedInstance.isCheckedCamp {
            btnCheckboxCamp.setImage(UIImage(named : "Unchecked Checkbox-32.png"), for: .normal)
            SingleTon.SharedInstance.isCheckedCamp = false
        } else {
            btnCheckboxCamp.setImage(UIImage(named : "Checked Checkbox 2-32.png"), for: .normal)
            SingleTon.SharedInstance.isCheckedCamp = true
        }
    }

    @IBAction func btnApplyTapped(_ sender: Any) {
        //TODO:-
        //HudBar.sharedInstance.showHudWithMessage(message: "Filtering...", view: self.view)
        print("Apply Tapped..!!")
        if SingleTon.SharedInstance.cameFromMarkersList! {
            let temp = self.storyboard?.instantiateViewController(withIdentifier: "MarkersListView") as! MarkersListView
            let naC = UINavigationController(rootViewController: temp)
            present(naC, animated: true, completion: nil)
            
        } else {
        
        let temp = self.storyboard?.instantiateViewController(withIdentifier: "DonateView") as! DonateView
        let naC = UINavigationController(rootViewController: temp)
        present(naC, animated: true, completion: nil)
        }
     }
   
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension FilterChecks : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: subViewFilter))! {
            return true
        }
        
        dismiss(animated: true, completion: nil)
        return false
    }
}

