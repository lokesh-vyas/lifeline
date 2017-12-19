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
    var addressLine : String = ""
    var city: String = ""
    var pinCode : String = ""
    var state : String = ""
    var country : String = ""
    var landMark : String = ""
    var latitude : String? = nil
    var longitude : String? = nil
    var CID : String? = nil
    var LoginID : String = ""
    var BloodGroup : String = ""
    var DonationType : String = ""
    var WhenNeeded : String = ""
    var NumUnits : String = ""
    var PatientName : String = ""
    var ContactPerson : String = ""
    var ContactNumber : String = ""
    var DoctorName : String = ""
    var DoctorContact : String = ""
    var DoctorEmailID : String = ""
    var CenterID : String = ""
    var CollectionCentreName : String = ""
    var PersonalAppeal : String = ""
    var SharedInSocialMedia : String = ""
    var CTypeOfOrg : String = ""
    var individualDetails : String = ""
    var hospitalName : String = ""
    var fromDate : String? = nil
    var toDate : String? = nil
    var individualContactNumber: String? = ""
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
    @IBOutlet weak var tblVIewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    var listMarkers : JSON!
    var listDetailArray = [MarkerListModel]()
    var searchController : UISearchController!
    var myContent = [String]()
    var filtered = [MarkerListModel]()
    var is_Searching: Bool!
    var listMaekerForShow = MarkerListModel()
    let btnListofMarkers = UIButton()
    var phoneCall = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        is_Searching = false
        self.searchBar.isHidden = true
        self.tblVIewTopConstraint.constant = 0
        
       //FIXME:- No need of listMarkers
       listMarkers = SingleTon.SharedInstance.sMarkers
        for i in 0..<listMarkers.count
        {
            print("My Data = \(listMarkers.count)")
            var marker = listMarkers[i]
            print(marker.count)
            let markerDetails = MarkerListModel()
            if marker["TypeOfOrg"] == 2 && SingleTon.SharedInstance.isCheckedCamp
            {
                markerDetails.name = String(describing: marker["Name"])
                markerDetails.workingHours = String(describing: marker["WorkingHours"])
                markerDetails.typeOfOrg = "2"
                markerDetails.id = String(describing: marker["ID"])
                markerDetails.toDate = Util.SharedInstance.showingDateToUser(dateString: String(describing: marker["ToDate"]))
                markerDetails.fromDate = Util.SharedInstance.showingDateToUser(dateString: String(describing: marker["FromDate"]))
                markerDetails.CampTimeDuration = "\(Util.SharedInstance.showingDateToUser(dateString: String(describing: marker["FromDate"]))) TO \(Util.SharedInstance.showingDateToUser(dateString: String(describing: marker["ToDate"])))"
                markerDetails.contactNumber = String(describing: marker["ContactNumber"])
                markerDetails.city = String(describing: marker["City"])
                markerDetails.pinCode = String(describing: marker["PINCode"])
                markerDetails.country = String(describing: marker["Country"])
                markerDetails.state = String(describing: marker["State"])
                markerDetails.landMark = String(describing: marker["LandMark"])
                markerDetails.addressLine = String(describing: marker["AddressLine"])
                markerDetails.emailAddress = String(describing: marker["Email"])
                markerDetails.addresssId = String(describing: marker["AddressId"])
                markerDetails.latitude = String(describing: marker["Latitude"])
                markerDetails.longitude = String(describing: marker["Longitude"])
                
                listDetailArray.append(markerDetails)
            }else if marker["TypeOfOrg"] == 1
            {
                if SingleTon.SharedInstance.isCheckedHospital
                {
                markerDetails.name = String(describing: marker["Name"])
                markerDetails.workingHours = String(describing: marker["WorkingHours"])
                markerDetails.id = String(describing: marker["ID"])
                markerDetails.typeOfOrg = "1"
                markerDetails.contactNumber = String(describing: marker["ContactNumber"])
                markerDetails.city = String(describing: marker["City"])
                markerDetails.pinCode = String(describing: marker["PINCode"])
                markerDetails.country = String(describing: marker["Country"])
                markerDetails.state = String(describing: marker["State"])
                markerDetails.landMark = String(describing: marker["LandMark"])
                markerDetails.addressLine = String(describing: marker["AddressLine"])
                markerDetails.emailAddress = String(describing: marker["Email"])
                markerDetails.addresssId = String(describing: marker["AddressId"])
                markerDetails.latitude = String(describing: marker["Latitude"])
                markerDetails.longitude = String(describing: marker["Longitude"])
                
                listDetailArray.append(markerDetails)
                }
                if String(describing: marker["Individuals"]) != "null" && SingleTon.SharedInstance.isCheckedIndividual
                {
                   /* markerDetails.individualDetails = String(describing: marker["Individuals"])
                    listDetailArray.append(markerDetails)*/
                    var indvidualArray = marker["Individuals"]["Individuals"]
                    if ((indvidualArray as? JSON)?.dictionary) != nil {
                        indvidualArray = JSON.init(arrayLiteral: indvidualArray)
                    }
                        for j in 0..<indvidualArray.count
                        {
                            var IndiMarker = indvidualArray[j]
                            let IndiMarkerDetails = MarkerListModel()
                            IndiMarkerDetails.name = String(describing: IndiMarker["UserName"])
                            IndiMarkerDetails.CID =  String(describing: IndiMarker["CID"])
                            IndiMarkerDetails.typeOfOrg = "3"
                            IndiMarkerDetails.CTypeOfOrg = "3"
                            IndiMarkerDetails.workingHours = String(describing: IndiMarker["WorkingHours"])
                            IndiMarkerDetails.descriptionForIndi = String(describing: IndiMarker["CName"])
                            IndiMarkerDetails.hospitalName = String(describing: marker["Name"])
                            IndiMarkerDetails.individualContactNumber = String(describing: IndiMarker["CContactNumber"])
                            listDetailArray.append(IndiMarkerDetails)
                        }
                }
}
        }
        self.tblView.performSelector(onMainThread: #selector(self.tblView.reloadData), with: nil, waitUntilDone: true)
        print(listDetailArray.count)
        print(listMarkers)
        print(listDetailArray)
        self.navigationController?.completelyTransparentBar()
        tblView.contentInset = UIEdgeInsetsMake(-35, 0.0, +195, 0.0)
        if SingleTon.SharedInstance.noMarkers == true {
            tblView.isHidden = true
            btnSearch.isEnabled = false
        } else {
            tblView.isHidden = false
            lblNoRequirement.text = ""
            btnListofMarkers.isHidden = false
            btnSearch.isEnabled = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    func loadList(notification: NSNotification){
        listMarkers = []
        listMarkers = JSON(SingleTon.SharedInstance.appendedMarkers) 
        print("when table reloads :\(listMarkers)^^^")
            self.tblView.performSelector(onMainThread: #selector(self.tblView.reloadData), with: nil, waitUntilDone: true)
            print("table is reloaded")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tblView.performSelector(onMainThread: #selector(self.tblView.reloadData), with: nil, waitUntilDone: true)
    }
    
    //MARK:- List Button action
    @IBAction func btnListClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
     @IBAction func btnSearchTapped(_ sender: Any) {
        self.searchBar.isHidden = false
        self.tblVIewTopConstraint.constant = 56
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        SingleTon.SharedInstance.cameFromMarkersList = true
        let temp = self.storyboard?.instantiateViewController(withIdentifier: "FilterChecks") as! FilterChecks
        temp.modalPresentationStyle = .overCurrentContext
        temp.view.backgroundColor = UIColor.clear
        present(temp, animated: true, completion: nil)
    }
    //MARK: btnCallTapped
    func btnCallTapped(sender:UIButton)
    {
        //print(self.phoneCall)
        let buttonRow = sender.tag
        var PhoneNumber:String = ""
        if listDetailArray[buttonRow].contactNumber! != "" {
            PhoneNumber = listDetailArray[buttonRow].contactNumber!
        }
        else if listDetailArray[buttonRow].individualContactNumber! != "" {
            PhoneNumber = listDetailArray[buttonRow].individualContactNumber!
        }
        print("My Latest phone number = \(PhoneNumber )")
        if let url = URL(string: "tel://\(String(describing: PhoneNumber))") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        else {
            print("call failed")
        }
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
        cell?.viewBackground.completelyTransparentView()
        if is_Searching == true
        {
                let listMaekerForShow = filtered[indexPath.row]
                print(listMaekerForShow.typeOfOrg)
        
                if listMaekerForShow.typeOfOrg == "1" {
                        // Hospital

                    cell?.lblUserName.text = listMaekerForShow.name
                    cell?.lblTimingForCamp.text = ""
                    cell?.imgDropForTiming.image = UIImage(named: "timer")
                    //cell?.viewCamp.isHidden = true
                    self.phoneCall = listMaekerForShow.contactNumber!
                    cell?.btnCall.tag = indexPath.row
                    cell?.btnCall.addTarget(self, action: #selector(MarkersListView.btnCallTapped(sender:)), for: .touchUpInside)
                    cell?.imgCamp.image = UIImage(named: "Hospital_Single_icon")
                    }
                else if listMaekerForShow.typeOfOrg == "2" {
                        // Camp
                    cell?.lblUserName.text = listMaekerForShow.name
                    cell?.lblTimingForCamp.text = listMaekerForShow.CampTimeDuration
                    cell?.imgDropForTiming.image = UIImage(named: "timer")
                    cell?.lblTimeForHospital.text = listMaekerForShow.workingHours
                    self.phoneCall = listMaekerForShow.contactNumber!
                    cell?.btnCall.tag = indexPath.row
                    cell?.btnCall.addTarget(self, action: #selector(MarkersListView.btnCallTapped(sender:)), for: .touchUpInside)
                    cell?.imgCamp.image = UIImage(named: "Camp_Single_icon")
                }
                else if listMaekerForShow.typeOfOrg == "3" {
                      //Individual
                    cell?.lblUserName.text = listMaekerForShow.name
                    cell?.lblTimingForCamp.text = listMaekerForShow.hospitalName
                    cell?.imgDropForTiming.image = UIImage(named: "drop_black")
                    cell?.lblTimeForHospital.text = listMaekerForShow.descriptionForIndi
                    self.phoneCall = listMaekerForShow.individualContactNumber!
                    cell?.btnCall.tag = indexPath.row
                    cell?.btnCall.addTarget(self, action: #selector(MarkersListView.btnCallTapped(sender:)), for: .touchUpInside)
                    cell?.imgCamp.image = UIImage(named: "Individual_Single_icon")
                }
        }
        else
        {
            listMaekerForShow = listDetailArray[indexPath.row]
            print(listMaekerForShow.typeOfOrg)
            if listMaekerForShow.typeOfOrg == "1"  // Hospital
            {
                cell?.lblUserName.text = listMaekerForShow.name
                cell?.lblTimingForCamp.text = ""
                cell?.imgDropForTiming.image = UIImage(named: "timer")
                cell?.lblTimeForHospital.text = listMaekerForShow.workingHours
                //self.phoneCall = listMaekerForShow.contactNumber!
                cell?.btnCall.tag = indexPath.row
                cell?.btnCall.addTarget(self, action: #selector(MarkersListView.btnCallTapped(sender:)), for: .touchUpInside)
                cell?.imgCamp.image = UIImage(named: "Hospital_Single_icon")
                print("My Hospital contact is = \(self.phoneCall)")
                print("Hospital contact is = \(listMaekerForShow.contactNumber!)")
            }else if(listMaekerForShow.typeOfOrg == "2")  // Camp
            {
                cell?.lblUserName.text = listMaekerForShow.name
                cell?.lblTimingForCamp.text = listMaekerForShow.CampTimeDuration
                cell?.imgDropForTiming.image = UIImage(named: "timer")
                cell?.lblTimeForHospital.text = listMaekerForShow.workingHours
                //self.phoneCall = listMaekerForShow.contactNumber!
                cell?.btnCall.tag = indexPath.row
                cell?.btnCall.addTarget(self, action: #selector(MarkersListView.btnCallTapped(sender:)), for: .touchUpInside)
                cell?.imgCamp.image = UIImage(named: "Camp_Single_icon")
                    
            }else if(listMaekerForShow.typeOfOrg == "3")  //Individual
            {
                cell?.lblUserName.text = listMaekerForShow.name
                cell?.lblTimingForCamp.text = listMaekerForShow.hospitalName
                cell?.imgDropForTiming.image = UIImage(named: "drop_black")
                cell?.lblTimeForHospital.text = listMaekerForShow.descriptionForIndi
               // self.phoneCall = listMaekerForShow.individualContactNumber!
                cell?.btnCall.tag = indexPath.row
                cell?.btnCall.addTarget(self, action: #selector(MarkersListView.btnCallTapped(sender:)), for: .touchUpInside)
                
                cell?.imgCamp.image = UIImage(named: "Individual_Single_icon")
                print("Individual contact is = \(listMaekerForShow.individualContactNumber!)")
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
        
        let TypeOfOrg = listDetailArray[indexPath.row].typeOfOrg
        var navigationControllerStack = UINavigationController()
        if TypeOfOrg == "2"
        {
            let cnfDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            MarkerData.SharedInstance.markerData["Name"] = listDetailArray[indexPath.row].name
            MarkerData.SharedInstance.markerData["ID"] = listDetailArray[indexPath.row].id
            MarkerData.SharedInstance.markerData["TypeOfOrg"] = listDetailArray[indexPath.row].typeOfOrg
            MarkerData.SharedInstance.markerData["ContactNumber"] = listDetailArray[indexPath.row].contactNumber
            MarkerData.SharedInstance.markerData["Email"] = listDetailArray[indexPath.row].emailAddress
            MarkerData.SharedInstance.markerData["WorkingHours"] = listDetailArray[indexPath.row].workingHours
            MarkerData.SharedInstance.markerData["City"] = listDetailArray[indexPath.row].city
            MarkerData.SharedInstance.markerData["PINCode"] = listDetailArray[indexPath.row].pinCode
            MarkerData.SharedInstance.markerData["Country"] = listDetailArray[indexPath.row].country
            MarkerData.SharedInstance.markerData["LandMark"] = listDetailArray[indexPath.row].landMark
            MarkerData.SharedInstance.markerData["AddressLine"] = listDetailArray[indexPath.row].addressLine
            MarkerData.SharedInstance.markerData["AddressId"] = listDetailArray[indexPath.row].addresssId
            MarkerData.SharedInstance.markerData["Latitude"] = listDetailArray[indexPath.row].latitude
            MarkerData.SharedInstance.markerData["Longitude"] = listDetailArray[indexPath.row].longitude
            MarkerData.SharedInstance.isNotIndividualAPN = false
            let newStr = listDetailArray[indexPath.row].CampTimeDuration
            let index1 = newStr?.index((newStr?.startIndex)!, offsetBy: 11)
            let ToDate = newStr?.substring(to: index1!)
            MarkerData.SharedInstance.markerData["ToDate"] = ToDate
            let index2 = newStr?.index((newStr?.startIndex)!, offsetBy: 15)
            let FromDate = newStr?.substring(from: index2!)
            MarkerData.SharedInstance.markerData["FromDate"] = FromDate
            navigationControllerStack = UINavigationController(rootViewController: cnfDonate)
        }
            
        else if TypeOfOrg == "1"
        {
            let cnfDonate = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmDonate") as! ConfirmDonate
            MarkerData.SharedInstance.markerData["Name"] = listDetailArray[indexPath.row].name
            MarkerData.SharedInstance.markerData["ID"] = listDetailArray[indexPath.row].id
            MarkerData.SharedInstance.markerData["TypeOfOrg"] = listDetailArray[indexPath.row].typeOfOrg
            MarkerData.SharedInstance.markerData["ContactNumber"] = listDetailArray[indexPath.row].contactNumber
            MarkerData.SharedInstance.markerData["Email"] = listDetailArray[indexPath.row].emailAddress
            MarkerData.SharedInstance.markerData["WorkingHours"] = listDetailArray[indexPath.row].workingHours
            MarkerData.SharedInstance.markerData["City"] = listDetailArray[indexPath.row].city
            MarkerData.SharedInstance.markerData["PINCode"] = listDetailArray[indexPath.row].pinCode
            MarkerData.SharedInstance.markerData["Country"] = listDetailArray[indexPath.row].country
            MarkerData.SharedInstance.markerData["LandMark"] = listDetailArray[indexPath.row].landMark
            MarkerData.SharedInstance.markerData["AddressLine"] = listDetailArray[indexPath.row].addressLine
            MarkerData.SharedInstance.markerData["AddressId"] = listDetailArray[indexPath.row].addresssId
            MarkerData.SharedInstance.markerData["Latitude"] = listDetailArray[indexPath.row].latitude
            MarkerData.SharedInstance.markerData["Longitude"] = listDetailArray[indexPath.row].longitude
            MarkerData.SharedInstance.isNotIndividualAPN = false
            navigationControllerStack = UINavigationController(rootViewController: cnfDonate)
        }
        else if TypeOfOrg == "3"
        {
            let indiCnfDonate = self.storyboard?.instantiateViewController(withIdentifier: "IndividualConfirmDonate") as! IndividualConfirmDonate
            indiCnfDonate.iID = listDetailArray[indexPath.row].CID!
            MarkerData.SharedInstance.oneRequestOfDonate["CID"] = listDetailArray[indexPath.row].CID
            MarkerData.SharedInstance.oneRequestOfDonate["CTypeOfOrg"] = listDetailArray[indexPath.row].typeOfOrg
            MarkerData.SharedInstance.isIndividualAPN = false
//            MarkerData.SharedInstance.markerData["Name"] = listDetailArray[indexPath.row].name
//            MarkerData.SharedInstance.markerData["ID"] = listDetailArray[indexPath.row].id
//            MarkerData.SharedInstance.markerData["TypeOfOrg"] = listDetailArray[indexPath.row].typeOfOrg
//            MarkerData.SharedInstance.markerData["ContactNumber"] = listDetailArray[indexPath.row].contactNumber
//            MarkerData.SharedInstance.markerData["Email"] = listDetailArray[indexPath.row].emailAddress
//            MarkerData.SharedInstance.markerData["WorkingHours"] = listDetailArray[indexPath.row].workingHours
//            MarkerData.SharedInstance.markerData["City"] = listDetailArray[indexPath.row].city
//            MarkerData.SharedInstance.markerData["PINCode"] = listDetailArray[indexPath.row].pinCode
//            MarkerData.SharedInstance.markerData["Country"] = listDetailArray[indexPath.row].country
//            MarkerData.SharedInstance.markerData["LandMark"] = listDetailArray[indexPath.row].landMark
//            MarkerData.SharedInstance.markerData["AddressLine"] = listDetailArray[indexPath.row].addressLine
//            MarkerData.SharedInstance.markerData["AddressId"] = listDetailArray[indexPath.row].addresssId
//            MarkerData.SharedInstance.markerData["Latitude"] = listDetailArray[indexPath.row].latitude
//            MarkerData.SharedInstance.markerData["Longitude"] = listDetailArray[indexPath.row].longitude
//            MarkerData.SharedInstance.oneRequestOfDonate["CID"] = listDetailArray[indexPath.row].CID
//            MarkerData.SharedInstance.isIndividualAPN = false
//
//            MarkerData.SharedInstance.markerData["LoginID"] = listDetailArray[indexPath.row].LoginID
//            MarkerData.SharedInstance.markerData["BloodGroup"] = listDetailArray[indexPath.row].BloodGroup
//            MarkerData.SharedInstance.markerData["DonationType"] = listDetailArray[indexPath.row].DonationType
//            MarkerData.SharedInstance.markerData["WhenNeeded"] = listDetailArray[indexPath.row].WhenNeeded
//            MarkerData.SharedInstance.markerData["NumUnits"] = listDetailArray[indexPath.row].NumUnits
//            MarkerData.SharedInstance.markerData["PatientName"] = listDetailArray[indexPath.row].PatientName
//            MarkerData.SharedInstance.markerData["ContactPerson"] = listDetailArray[indexPath.row].ContactPerson
//            MarkerData.SharedInstance.markerData["ContactNumber"] = listDetailArray[indexPath.row].ContactNumber
//            MarkerData.SharedInstance.markerData["DoctorName"] = listDetailArray[indexPath.row].DoctorName
//            MarkerData.SharedInstance.markerData["DoctorContact"] = listDetailArray[indexPath.row].DoctorContact
//            MarkerData.SharedInstance.markerData["DoctorEmailID"] = listDetailArray[indexPath.row].DoctorEmailID
//            MarkerData.SharedInstance.markerData["CenterID"] = listDetailArray[indexPath.row].CenterID
//            MarkerData.SharedInstance.markerData["CollectionCentreName"] = listDetailArray[indexPath.row].CollectionCentreName
//            MarkerData.SharedInstance.markerData["PersonalAppeal"] = listDetailArray[indexPath.row].PersonalAppeal
//            MarkerData.SharedInstance.oneRequestOfDonate["SharedInSocialMedia"] = listDetailArray[indexPath.row].SharedInSocialMedia
//            MarkerData.SharedInstance.oneRequestOfDonate["CTypeOfOrg"] = listDetailArray[indexPath.row].CTypeOfOrg
            navigationControllerStack = UINavigationController(rootViewController: indiCnfDonate)
        }
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
            
            self.tblView.performSelector(onMainThread: #selector(self.tblView.reloadData), with: nil, waitUntilDone: true)
        }
        else
        {
            is_Searching = true
            for i in 0 ..< listDetailArray.count
            {
                let currentString = String(describing: listDetailArray[i].name)
                let searchDetails = MarkerListModel()
                if currentString.lowercased().contains(searchText.lowercased()) {
                    searchDetails.name = String(describing: listDetailArray[i].name)
                    if let a = listDetailArray[i].workingHours
                    {
                        searchDetails.workingHours = a
                    }
                    searchDetails.typeOfOrg = String(describing: listDetailArray[i].typeOfOrg)
                    searchDetails.id = String(describing: listDetailArray[i].id)
                    if let c = listDetailArray[i].CampTimeDuration
                    {
                        searchDetails.CampTimeDuration = c
                    }
                    if let d = listDetailArray[i].descriptionForIndi
                    {
                        searchDetails.descriptionForIndi = d
                    }
                    filtered.append(searchDetails)
                }}
          print(filtered)
        }
            self.tblView.performSelector(onMainThread: #selector(self.tblView.reloadData), with: nil, waitUntilDone: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
          self.searchBar.endEditing(true)
          self.searchBar.resignFirstResponder()
          self.searchBar.isHidden = true
          self.tblVIewTopConstraint.constant = 0
    }
}

