//
//  MarkersListView.swift
//  lifeline
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MarkersListView: UIViewController {

    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var lblNoRequirement : UILabel!
    var listMarkers : JSON!
    var searchController : UISearchController!
    var myContent = [String]()
    var filtered : JSON!
    var is_Searching: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        is_Searching = false
        SingleTon.SharedInstance.hospitalsOnList.arrayObject?.removeAll()
        SingleTon.SharedInstance.individualsOnList.arrayObject?.removeAll()
        SingleTon.SharedInstance.compaignOnList.arrayObject?.removeAll()
       //FIXME:- No need of listMarkers
       listMarkers = SingleTon.SharedInstance.sMarkers
        self.navigationController?.completelyTransparentBar()
        tblView.contentInset = UIEdgeInsetsMake(-35, 0.0, +195, 0.0)
        if SingleTon.SharedInstance.noMarkers == true {
            tblView.isHidden = true
        } else {
            tblView.isHidden = false
            lblNoRequirement.text = ""
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        filtered = []
    }
    
    func loadList(notification: NSNotification){
        listMarkers = []
        listMarkers = JSON(SingleTon.SharedInstance.appendedMarkers) 
        print("when table reloads :\(listMarkers)^^^")
        self.tblView.reloadData()
        print("table is reloaded")
    }
    

    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        SingleTon.SharedInstance.cameFromMarkersList = true
        let temp = self.storyboard?.instantiateViewController(withIdentifier: "FilterChecks") as! FilterChecks
        temp.modalPresentationStyle = .overCurrentContext
        temp.view.backgroundColor = UIColor.clear
        present(temp, animated: true, completion: nil)
    }
}
extension MarkersListView : UITableViewDataSource {
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     print("Total items in LisView = \(listMarkers.count)")
     if listMarkers.count <= 0
     {
         return 0
     }
        if is_Searching == true
        {
            return filtered.count
        }
        else
        {
            return listMarkers.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier:String = "DonateListCell"
        var cell:DonateListCell? = tblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? DonateListCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("DonateListCell", owner: self, options: nil)!
            cell = nib[0] as? DonateListCell
            print("cell = \(String(describing: cell))")
        }
        
    
        if is_Searching == true
        {
            if SingleTon.SharedInstance.isCheckedIndividual || SingleTon.SharedInstance.isCheckedHospital || SingleTon.SharedInstance.isCheckedCamp {
                
                if filtered[indexPath.row]["TypeOfOrg"] == "1" {
                 
                    if String(describing: filtered[indexPath.row]["Individuals"]) == "null" && SingleTon.SharedInstance.isCheckedHospital {
                        // Hospital
                        cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "804000"))
                        cell?.viewBottomForColor.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "804000")
                        cell?.lblUserName.text = String(describing: filtered[indexPath.row]["Name"])
                        cell?.lblTimeForHospital.text = String(describing: filtered[indexPath.row]["WorkingHours"])

                        let temp = "\(["Name" : String(describing: filtered[indexPath.row]["Name"]), "WorkingHours" : String(describing: filtered[indexPath.row]["WorkingHours"])])"
                    SingleTon.SharedInstance.hospitalsOnList.arrayObject?.append(temp)
                    }
                    else if String(describing: filtered[indexPath.row]["Individuals"]) != "null" && SingleTon.SharedInstance.isCheckedIndividual {
                        // Individual
                        cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "B60B16"))
                        cell?.viewBottomForColor.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "B60B16")
                        cell?.lblUserName.text = String(describing: filtered[indexPath.row]["Name"])
                        cell?.lblTimeForHospital.text = String(describing: filtered[indexPath.row]["WorkingHours"])
                    
                        
                        let temp = "\(["Name" : String(describing: filtered[indexPath.row]["Name"]), "WorkingHours" : String(describing: filtered[indexPath.row]["WorkingHours"])])"
                        
                        SingleTon.SharedInstance.individualsOnList.arrayObject?.append(temp)
                    }
                    
                } else if filtered[indexPath.row]["TypeOfOrg"] == "2" && SingleTon.SharedInstance.isCheckedCamp  {
                      //CAMP
                    cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "35CE11"))
                    cell?.viewBottomForColor.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "35CE11")
          
                    cell?.lblTimingForCamp.text = ("\(String(describing: filtered[indexPath.row]["FromDate"])) TO  \(String(describing: filtered[indexPath.row]["ToDate"]))")

                    cell?.lblUserName.text = String(describing: filtered[indexPath.row]["Name"])
                    cell?.lblTimeForHospital.text = String(describing: filtered[indexPath.row]["WorkingHours"])
                    let temp = "\(["Name" : String(describing: filtered[indexPath.row]["Name"]), "WorkingHours" : String(describing: filtered[indexPath.row]["WorkingHours"])])"
                    SingleTon.SharedInstance.compaignOnList.arrayObject?.append(temp)
                } }
            else {
            }

        }
        else
        {
        if SingleTon.SharedInstance.isCheckedIndividual || SingleTon.SharedInstance.isCheckedHospital || SingleTon.SharedInstance.isCheckedCamp {
        
         if listMarkers[indexPath.row]["TypeOfOrg"].int == 1 {
            if String(describing: listMarkers[indexPath.row]["Individuals"]) == "null" && SingleTon.SharedInstance.isCheckedHospital {
                // Hospital
                cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "804000"))
                cell?.viewBottomForColor.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "804000")
                
                cell?.lblUserName.text = String(describing: listMarkers[indexPath.row]["Name"])
                cell?.lblTimeForHospital.text = String(describing: listMarkers[indexPath.row]["WorkingHours"])
               
                let temp = ["Name" : String(describing: listMarkers[indexPath.row]["Name"]), "WorkingHours" : String(describing: listMarkers[indexPath.row]["WorkingHours"]), "TypeOfOrg" : String(describing: listMarkers[indexPath.row]["TypeOfOrg"])]
                
                SingleTon.SharedInstance.sMarkers.arrayObject?.append(temp)
            }
            else if String(describing: listMarkers[indexPath.row]["Individuals"]) != "null" && SingleTon.SharedInstance.isCheckedIndividual {
                //Individual
                cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "B60B16"))
                cell?.viewBottomForColor.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "B60B16")
                cell?.lblUserName.text = String(describing: listMarkers[indexPath.row]["Name"])
                cell?.lblTimeForHospital.text = String(describing: listMarkers[indexPath.row]["WorkingHours"])
                
                let temp = ["Name" : String(describing: listMarkers[indexPath.row]["Name"]), "WorkingHours" : String(describing: listMarkers[indexPath.row]["WorkingHours"]), "TypeOfOrg" : String(describing: listMarkers[indexPath.row]["TypeOfOrg"])]
                
                SingleTon.SharedInstance.sMarkers.arrayObject?.append(temp)
            }
            
        } else if listMarkers[indexPath.row]["TypeOfOrg"].int == 2 && SingleTon.SharedInstance.isCheckedCamp  {
            //CAMP
            cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "35CE11"))
            cell?.viewBottomForColor.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "35CE11")
            
            
            cell?.lblTimingForCamp.text = ("\(Util.SharedInstance.showingDateToUser(dateString: String(describing: listMarkers[indexPath.row]["FromDate"]))) TO  \(Util.SharedInstance.showingDateToUser(dateString: String(describing: listMarkers[indexPath.row]["ToDate"])))")
            cell?.lblUserName.text = String(describing: listMarkers[indexPath.row]["Name"])
            cell?.lblTimeForHospital.text = String(describing: listMarkers[indexPath.row]["WorkingHours"])
            let temp = ["Name" : String(describing: listMarkers[indexPath.row]["Name"]), "WorkingHours" : String(describing: listMarkers[indexPath.row]["WorkingHours"]), "FromDate" : String(describing: listMarkers[indexPath.row]["FromDate"]), "ToDate" : String(describing: listMarkers[indexPath.row]["ToDate"]), "TypeOfOrg" : String(describing: listMarkers[indexPath.row]["TypeOfOrg"])]
            SingleTon.SharedInstance.sMarkers.arrayObject?.append(temp)
            } }
        else {
        }
        }
        return cell!
    }
}
extension MarkersListView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cnfDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
        let tempDictionary = JSON.init(dictionaryLiteral: ("Data",listMarkers))
       // MarkerData.SharedInstance.markerData = tempDictionary["Data"].arrayObject
        let navigationControllerStack = UINavigationController(rootViewController: cnfDonate)
        self.present(navigationControllerStack, animated: true, completion: nil)
        
    }
}

extension MarkersListView : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("You're trying to search something...")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = []
        print(filtered.count)
        if (searchBar.text?.isEmpty)!
        {
            is_Searching = false
            self.tblView.reloadData()
        }
        else
        {
            is_Searching = true
            for i in 0 ..< listMarkers.count
            {
                var currentString = String(describing: listMarkers[i]["Name"])
                if currentString.lowercased().contains(searchText.lowercased()) {
                    let temp = ["Name" : String(describing: listMarkers[i]["Name"]), "WorkingHours" : String(describing: listMarkers[i]["WorkingHours"]), "TypeOfOrg" : String(describing: listMarkers[i]["TypeOfOrg"]), "FromDate" : String(describing: listMarkers[i]["FromDate"]), "ToDate" : String(describing: listMarkers[i]["ToDate"])]
                    filtered.arrayObject?.append(temp)
                }
            }
          print(filtered)
          
        }
            self.tblView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        dismiss(animated: true, completion: nil)
    }
}
