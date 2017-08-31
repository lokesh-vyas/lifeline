//
//  FilterChecks.swift
//  lifeline
//
//  Created by Apple on 24/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class SingleTon {
    
    var isCheckedIndividual = true
    var isCheckedHospital = true
    var isCheckedCamp = true
    var noMarkers : Bool?
    var cameFromMarkersList : Bool?
    var currentLatitude : CLLocationDegrees!
    var currentLongitude : CLLocationDegrees!
    var sMarkers : JSON = []
    var appendedMarkers = [Dictionary<String,Any>]()
    var cameFromFilterChecks: Bool?
    var individualsOnList : JSON = []
    var hospitalsOnList: JSON = []
    var compaignOnList: JSON = []

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SingleTon.SharedInstance.appendedMarkers = []
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
        HudBar.sharedInstance.showHudWithMessage(message: "Filtering...", view: self.view)
        print("Apply Tapped..!!")
        
        if SingleTon.SharedInstance.cameFromMarkersList! {
            
           /* var tempDict = [String : Any]()
            
            var jDict = SingleTon.SharedInstance.sMarkers//["Data"]
            
            //SingleTon.SharedInstance.sMarkers = []
            
            for (i, _) in jDict.enumerated() {
                
                if SingleTon.SharedInstance.isCheckedIndividual || SingleTon.SharedInstance.isCheckedHospital || SingleTon.SharedInstance.isCheckedCamp {
                /*if jDict[i]["TypeOfOrg"].int == 1 {
                    if String(describing: jDict[i]["Individuals"]) != "null" && SingleTon.SharedInstance.isCheckedIndividual
                    { // Hospital
                        
                        tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                        tempDict["Name"] = jDict[i]["Name"]
                        tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                        
                        SingleTon.SharedInstance.appendedMarkers.append(tempDict)
                    }
                    else if String(describing: jDict[i]["Individuals"]) == "null" && SingleTon.SharedInstance.isCheckedHospital
                    { // Hospital
                        
                        tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                        tempDict["Name"] = jDict[i]["Name"]
                        tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                        SingleTon.SharedInstance.appendedMarkers.append(tempDict)
                    }
                    
                } else if jDict[i]["TypeOfOrg"].int == 2 && SingleTon.SharedInstance.isCheckedCamp { // Camps
                    
                    tempDict["FromDate"] = jDict[i]["FromDate"]
                    tempDict["ToDate"] = jDict[i]["ToDate"]
                    tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                    tempDict["Name"] = jDict[i]["Name"]
                    tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                    SingleTon.SharedInstance.appendedMarkers.append(tempDict)
                    }
                }*/
                    
                    if jDict[i]["TypeOfOrg"] == 2 && SingleTon.SharedInstance.isCheckedCamp
                    {
                        tempDict["FromDate"] = jDict[i]["FromDate"]
                        tempDict["ToDate"] = jDict[i]["ToDate"]
                        tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                        tempDict["Name"] = jDict[i]["Name"]
                        tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                        tempDict["ID"] = jDict[i]["ID"]
                        tempDict["ContactNumber"] = jDict[i]["ContactNumber"]
                        tempDict["City"] = jDict[i]["City"]
                        tempDict["PINCode"] = jDict[i]["PINCode"]
                        tempDict["Country"] = jDict[i]["Country"]
                        tempDict["LandMark"] = jDict[i]["LandMark"]
                        tempDict["AddressLine"] = jDict[i]["AddressLine"]
                        tempDict["AddressId"] = jDict[i]["AddressId"]
                        tempDict["Latitude"] = jDict[i]["Latitude"]
                        tempDict["Longitude"] = jDict[i]["Longitude"]
                        tempDict["Email"] = jDict[i]["Email"]
                        tempDict["State"] = jDict[i]["State"]
                        
                        SingleTon.SharedInstance.appendedMarkers.append(tempDict)
                        
                    }else
                    {
                        if jDict[i]["TypeOfOrg"] == 1 && SingleTon.SharedInstance.isCheckedHospital
                        {
                            tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                            tempDict["Name"] = jDict[i]["Name"]
                            tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                            tempDict["ID"] = jDict[i]["ID"]
                            tempDict["ContactNumber"] = jDict[i]["ContactNumber"]
                            tempDict["City"] = jDict[i]["City"]
                            tempDict["PINCode"] = jDict[i]["PINCode"]
                            tempDict["Country"] = jDict[i]["Country"]
                            tempDict["LandMark"] = jDict[i]["LandMark"]
                            tempDict["AddressLine"] = jDict[i]["AddressLine"]
                            tempDict["AddressId"] = jDict[i]["AddressId"]
                            tempDict["Latitude"] = jDict[i]["Latitude"]
                            tempDict["Longitude"] = jDict[i]["Longitude"]
                            tempDict["State"] = jDict[i]["State"]
                        
                            SingleTon.SharedInstance.appendedMarkers.append(tempDict)
                        }
                        else if jDict[i]["TypeOfOrg"] == 3 && SingleTon.SharedInstance.isCheckedIndividual
                        {
                            tempDict["TypeOfOrg"] = jDict[i]["TypeOfOrg"]
                            tempDict["Name"] = jDict[i]["UserName"]
                            tempDict["WorkingHours"] = jDict[i]["WorkingHours"]
                            tempDict["ID"] = jDict[i]["ID"]
                            tempDict["ContactNumber"] = jDict[i]["ContactNumber"]
                            tempDict["City"] = jDict[i]["City"]
                            tempDict["PINCode"] = jDict[i]["PINCode"]
                            tempDict["Country"] = jDict[i]["Country"]
                            tempDict["LandMark"] = jDict[i]["LandMark"]
                            tempDict["AddressLine"] = jDict[i]["AddressLine"]
                            tempDict["AddressId"] = jDict[i]["AddressId"]
                            tempDict["Latitude"] = jDict[i]["Latitude"]
                            tempDict["Longitude"] = jDict[i]["Longitude"]
                            tempDict["State"] = jDict[i]["State"]
                            tempDict["CID"] = jDict[i]["CID"]
                            tempDict["CTypeOfOrg"] = "3"
                            tempDict["CName"] = jDict[i]["CName"]

                        }
                    }
    
                }
                if !SingleTon.SharedInstance.isCheckedIndividual && !SingleTon.SharedInstance.isCheckedHospital && !SingleTon.SharedInstance.isCheckedCamp {
                    SingleTon.SharedInstance.sMarkers = []
                    SingleTon.SharedInstance.appendedMarkers = []
                    SingleTon.SharedInstance.sMarkers.arrayObject?.removeAll()
                    SingleTon.SharedInstance.noMarkers = true
                }
                else {
                    
                    SingleTon.SharedInstance.noMarkers = false
                }
                }
           //SingleTon.SharedInstance.sMarkers = SingleTon.SharedInstance.appendedMarkers
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            print("+++ appended Marker Data is \(SingleTon.SharedInstance.appendedMarkers)+++")
            dismiss(animated: true, completion: nil)*/
            
            let temp = self.storyboard?.instantiateViewController(withIdentifier: "MarkersListView") as! MarkersListView
            let naC = UINavigationController(rootViewController: temp)
            present(naC, animated: true, completion: nil)
            
        } else {
            let temp = self.storyboard?.instantiateViewController(withIdentifier: "DonateView") as! DonateView
            let naC = UINavigationController(rootViewController: temp)
            present(naC, animated: true, completion: nil)

        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
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

