//
//  MarkersListView.swift
//  lifeline
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MarkerListModel
{
    var name : String = ""
    var id : String = ""
    var typeOfOrg : String = ""
    var address : String? = nil
    var contactNumber : String? = ""
    var emailAddress : String? = nil
    var descriptionForIndi : String? = nil
    var workingHours: String? = nil
    var CampTimeDuration : String? = nil
    var addresssId : String = ""
    var city: String = ""
    var pinCode : String = ""
    var state : String = ""
    var country : String = ""
    var landMark : String = ""
}
class IndividualMarkerData
{
    var name : String = ""
    var id : String = ""
    var typeOfOrg : String = ""
    var contactNumber : String? = ""
    var emailAddress : String? = nil
    var descriptionForIndi : String? = nil
}

class MarkersListView: UIViewController {

    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var lblNoRequirement : UILabel!
    var listMarkers : JSON!
    var listDetailArray = [MarkerListModel]()
    var searchController : UISearchController!
    var myContent = [String]()
    var filtered = [MarkerListModel]()
    var is_Searching: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        is_Searching = false
       //FIXME:- No need of listMarkers
       listMarkers = SingleTon.SharedInstance.sMarkers
        
        for i in 0..<listMarkers.count
        {
            var marker = listMarkers[i]
            print(marker)
            let markerDetails = MarkerListModel()
            if marker["TypeOfOrg"] == 2
            {
                markerDetails.name = String(describing: marker["Name"])
                markerDetails.workingHours = String(describing: marker["WorkingHours"])
                markerDetails.typeOfOrg = "2"
                markerDetails.id = String(describing: marker["ID"])
                markerDetails.CampTimeDuration = "\(Util.SharedInstance.showingDateToUser(dateString: String(describing: marker["FromDate"]))) TO \(Util.SharedInstance.showingDateToUser(dateString: String(describing: marker["ToDate"])))"
                markerDetails.contactNumber = String(describing: marker["ContactNumber"])
                markerDetails.city = String(describing: marker["City"])
                markerDetails.pinCode = String(describing: marker["PINCode"])
                markerDetails.state = String(describing: marker["Country"])
                markerDetails.landMark = String(describing: marker["LandMark"])
        
                listDetailArray.append(markerDetails)
            }else{
                markerDetails.name = String(describing: marker["Name"])
                markerDetails.workingHours = String(describing: marker["WorkingHours"])
                markerDetails.id = String(describing: marker["ID"])
                markerDetails.typeOfOrg = "1"
                markerDetails.contactNumber = String(describing: marker["ContactNumber"])
                markerDetails.city = String(describing: marker["City"])
                markerDetails.pinCode = String(describing: marker["PINCode"])
                markerDetails.state = String(describing: marker["Country"])
                markerDetails.landMark = String(describing: marker["LandMark"])
                listDetailArray.append(markerDetails)
                if marker["Individuals"] != "null"
                {
                   
                    var indvidualArray = marker["Individuals"]["Individuals"]
                    
                    if ((indvidualArray as? JSON)?.dictionary) != nil {
                        indvidualArray = JSON.init(arrayLiteral: indvidualArray)
                    }
                        for j in 0..<indvidualArray.count
                        {
                            var IndiMarker = indvidualArray[j]
                            let IndiMarkerDetails = MarkerListModel()
                            IndiMarkerDetails.name = String(describing: IndiMarker["UserName"])
                            IndiMarkerDetails.id =  String(describing: IndiMarker["CID"])
                            IndiMarkerDetails.typeOfOrg = "3"
                            IndiMarkerDetails.workingHours = String(describing: IndiMarker["WorkingHours"])
                            IndiMarkerDetails.descriptionForIndi = String(describing: IndiMarker["CName"])
                        
                            listDetailArray.append(IndiMarkerDetails)
                        }
                }
              }
        }
        self.tblView.reloadData()
        print(listDetailArray.count)
        print(listMarkers)
        self.navigationController?.completelyTransparentBar()
        tblView.contentInset = UIEdgeInsetsMake(-35, 0.0, +195, 0.0)
        if SingleTon.SharedInstance.noMarkers == true {
            tblView.isHidden = true
        } else {
            tblView.isHidden = false
            lblNoRequirement.text = ""
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
       // filtered = []
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
            return listDetailArray.count
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
        cell?.constraintForHeightCamp.constant = 0
        UIView.animate(withDuration: Double(0.1), animations: {
            self.view.layoutIfNeeded()
        })
        if is_Searching == true
        {
                let listMaekerForShow = filtered[indexPath.row]
                print(listMaekerForShow.typeOfOrg)
            
                cell?.viewBackground.backgroundColor = UIColor.clear
                cell?.viewBottomForColor.backgroundColor = UIColor.clear
                cell?.viewBackground.addGradientWithColor(color: UIColor.clear)
                cell?.viewBottomForColor.addGradientWithColor(color: UIColor.clear)
                if listMaekerForShow.typeOfOrg == "1" {
                        // Hospital
                    
                    cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "804000"))
                    cell?.viewBottomForColor.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "804000"))
                    cell?.lblUserName.text = listMaekerForShow.name
                    cell?.lblTimingForCamp.text = ""
                    cell?.imgDropForTiming.image = UIImage(named: "timer")
                    cell?.viewCamp.isHidden = true
                    }
                else if listMaekerForShow.typeOfOrg == "2" {
                        // Camp
                    cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "35CE11"))
                    cell?.viewBottomForColor.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "35CE11"))
                    cell?.lblUserName.text = listMaekerForShow.name
                    cell?.lblTimingForCamp.text = listMaekerForShow.CampTimeDuration
                    cell?.viewCamp.isHidden = false
                    cell?.imgDropForTiming.image = UIImage(named: "timer")
                    cell?.lblTimeForHospital.text = listMaekerForShow.workingHours
                }
                else if listMaekerForShow.typeOfOrg == "3" {
                      //Individual
                    cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "B60B16"))
                    cell?.viewBottomForColor.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "B60B16"))
                    cell?.lblUserName.text = listMaekerForShow.name
                    cell?.lblTimingForCamp.text = ""
                    cell?.viewCamp.isHidden = true
                    cell?.imgDropForTiming.image = UIImage(named: "drop_black")
                    cell?.lblTimeForHospital.text = listMaekerForShow.descriptionForIndi
                }
        }
        else
        {
           
            let listMaekerForShow = listDetailArray[indexPath.row]
            print(listMaekerForShow.typeOfOrg)
           
            cell?.viewBackground.backgroundColor = UIColor.clear
            cell?.viewBottomForColor.backgroundColor = UIColor.clear
            cell?.viewBackground.addGradientWithColor(color: UIColor.clear)
            cell?.viewBottomForColor.addGradientWithColor(color: UIColor.clear)
            if listMaekerForShow.typeOfOrg == "1"
            {
                cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "804000"))
                cell?.viewBottomForColor.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "804000"))
                cell?.lblUserName.text = listMaekerForShow.name
                cell?.lblTimingForCamp.text = ""
                cell?.imgDropForTiming.image = UIImage(named: "timer")
                cell?.viewCamp.isHidden = true
                
                cell?.lblTimeForHospital.text = listMaekerForShow.workingHours
            }else if(listMaekerForShow.typeOfOrg == "2")
            {
                cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "35CE11"))
                cell?.viewBottomForColor.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "35CE11"))
                cell?.lblUserName.text = listMaekerForShow.name
                cell?.lblTimingForCamp.text = listMaekerForShow.CampTimeDuration
                cell?.viewCamp.isHidden = false
                cell?.imgDropForTiming.image = UIImage(named: "timer")
                cell?.lblTimeForHospital.text = listMaekerForShow.workingHours
            }else if(listMaekerForShow.typeOfOrg == "3")
            {
                cell?.viewBackground.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "B60B16"))
                cell?.viewBottomForColor.addGradientWithColor(color: Util.SharedInstance.hexStringToUIColor(hex: "B60B16"))
                cell?.lblUserName.text = listMaekerForShow.name
                cell?.lblTimingForCamp.text = ""
                cell?.viewCamp.isHidden = true
                cell?.imgDropForTiming.image = UIImage(named: "drop_black")
                cell?.lblTimeForHospital.text = listMaekerForShow.descriptionForIndi
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
        //MarkerData.SharedInstance.markerData = ["Data" : listDetailArray[indexPath.row]]
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
            for i in 0 ..< listDetailArray.count
            {
                var currentString = String(describing: listDetailArray[i].name)
                let searchDetails = MarkerListModel()
                if currentString.lowercased().contains(searchText.lowercased()) {
                    searchDetails.name = String(describing: listDetailArray[i].name)
                    searchDetails.workingHours = String(describing: listDetailArray[i].workingHours)
                    searchDetails.typeOfOrg = String(describing: listDetailArray[i].typeOfOrg)
                    searchDetails.id = String(describing: listDetailArray[i].id)
                    searchDetails.CampTimeDuration = String(describing: listDetailArray[i].CampTimeDuration)
                    searchDetails.descriptionForIndi = String(describing: listDetailArray[i].descriptionForIndi)
                    filtered.append(searchDetails)
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
}
