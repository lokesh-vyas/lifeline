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
//    var listMarker2 : JSON = []
    var listMarkers : JSON!
    var searchController : UISearchController!
    var myContent = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FIXME:- No need of listMarkers
        listMarkers = SingleTon.SharedInstance.sMarkers//["Data"] //listMarker2["Data"]
        self.navigationController?.completelyTransparentBar()
        tblView.contentInset = UIEdgeInsetsMake(-35, 0.0, +195, 0.0)
        if SingleTon.SharedInstance.noMarkers == true {
            tblView.isHidden = true
        } else {
            tblView.isHidden = false
            lblNoRequirement.text = ""
        }
        for (i, _) in listMarkers.enumerated() {
            myContent.append(String(describing: listMarkers[i]["Name"]))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    func loadList(notification: NSNotification){
        listMarkers = []
        listMarkers = JSON(SingleTon.SharedInstance.appendedMarkers) 
        print(listMarkers)
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
       return listMarkers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier:String = "HospitalListCell"
        var cell:HospitalListCell? = tblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HospitalListCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("HospitalListCell", owner: self, options: nil)!
            cell = nib[0] as? HospitalListCell
            print("cell = \(String(describing: cell))")
        }
        if listMarkers[indexPath.row]["TypeOfOrg"].int == 1 {
            if String(describing: listMarkers[indexPath.row]["Individuals"]) == "null" && SingleTon.SharedInstance.isCheckedHospital {
                cell?.lblHospitalName.text = String(describing: listMarkers[indexPath.row]["Name"])
                cell?.lblCityName.text = String(describing: listMarkers[indexPath.row]["WorkingHours"])
                cell?.lblHospitalName.textColor = UIColor.blue //hospital
                cell?.lblCityName.textColor = UIColor.blue
            }
            else if String(describing: listMarkers[indexPath.row]["Individuals"]) != "null" && SingleTon.SharedInstance.isCheckedIndividual {
                cell?.lblHospitalName.text = String(describing: listMarkers[indexPath.row]["Name"])
                cell?.lblCityName.text = String(describing: listMarkers[indexPath.row]["WorkingHours"])
                cell?.lblHospitalName.textColor = UIColor.red // Individuals
                cell?.lblCityName.textColor = UIColor.red
            }
            
        } else if listMarkers[indexPath.row]["TypeOfOrg"].int == 2 && SingleTon.SharedInstance.isCheckedCamp  {
            cell?.lblHospitalName.text = String(describing: listMarkers[indexPath.row]["Name"])
            cell?.lblCityName.text = String(describing: listMarkers[indexPath.row]["WorkingHours"])
            cell?.lblHospitalName.textColor = UIColor.green // Campaign
            cell?.lblCityName.textColor = UIColor.green
        }
       /*else
       {
           listMarkers.arrayObject?.remove(at: indexPath.row)
           tblView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
       }*/
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
        let navigationControllerStack = UINavigationController(rootViewController: cnfDonate)
        self.present(navigationControllerStack, animated: true, completion: nil)
        
    }
}

extension MarkersListView : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("You're trying to search something...")
//        searchController.searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

//        var filterdTerms = [String]()
//        filterdTerms = myContent.filter { term in
//            return term.lowercased().contains(searchText.lowercased())listMarkers
//        }
//        self.tblView.reloadData()
        
        let searchPredicate : NSPredicate = NSPredicate(format: "listMarkers CONTAINS[c] %@", searchText)
//            let array = (listMarkers as NSArray).filtered(using: searchPredicate)
//            print ("array = \(array)")
            
            self.tblView.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
        
    }

}

