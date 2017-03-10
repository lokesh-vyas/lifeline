//
//  HospitalListView.swift
//  lifeline
//
//  Created by iSteer on 14/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol HospitalListCompletDataProtocol
{
    func SuccessHospitalListCompletData(ListData:HospitalListModel)
}
class HospitalListView: UIViewController
{
    @IBOutlet weak var lblListNotAvailable: UILabel!
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBarText: UISearchBar!
    var searchFilterArray = [JSON]()
    var delegate:HospitalListCompletDataProtocol?
    
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchTableView.isHidden = true
        self.searchTableView.rowHeight = UITableViewAutomaticDimension
        self.lblListNotAvailable.isHidden = true
        searchBarText.becomeFirstResponder()
        searchTableView.contentInset = UIEdgeInsetsMake(-35, 0.0, +195, 0.0)
        self.navigationController?.completelyTransparentBar()
    }
}
//MARK:- SearchBar
extension HospitalListView:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == ""
        {
            searchFilterArray.removeAll()
            searchTableView.isHidden = true
            self.lblListNotAvailable.isHidden = true
            return
        }
        HospitalListInteractor.SharedInstance.delegate = self
        HospitalListInteractor.SharedInstance.HospitalSearchByString(searchString: searchText.lowercased())
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- Tableview Delegate
extension HospitalListView:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchFilterArray.count > 0
        {
            searchTableView.isHidden = false
            self.lblListNotAvailable.isHidden = true
            return searchFilterArray.count
        }
        searchTableView.isHidden = true
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier:String = "HospitalListCell"
        var cell:HospitalListCell? = searchTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HospitalListCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("HospitalListCell", owner: self, options: nil)!
            cell = nib[0] as? HospitalListCell
        }
        if searchFilterArray.count < 1
        {
            return cell!
        }
        let hopitalSearchDict = searchFilterArray[indexPath.row]
        cell?.lblHospitalName.text = hopitalSearchDict["Name"].string
        cell?.lblCityName.text = hopitalSearchDict["AddressLine"].string
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let hospitalSearchDict = searchFilterArray[indexPath.row]
        let hospitalModel:HospitalListModel = HospitalListModel()
        
        if  hospitalSearchDict["CenterID"].string != nil
        {
            hospitalModel.CentreID = hospitalSearchDict["CenterID"].string!
        }
        else
        {
            let centreID = hospitalSearchDict["CenterID"].int!
            hospitalModel.CentreID = String(centreID)
        }
        
        hospitalModel.AddressLine = hospitalSearchDict["AddressLine"].string
        hospitalModel.City = hospitalSearchDict["City"].string
        hospitalModel.HospitalName = hospitalSearchDict["Name"].string
        hospitalModel.PINCode = hospitalSearchDict["PINCode"].string
        
        hospitalModel.HospitalContactNumber = hospitalSearchDict["ContactNumber"].int
        hospitalModel.Landmark = hospitalSearchDict["LandMark"].string
        if hospitalSearchDict["Latitude"].string != nil
        {
            hospitalModel.Latitude = hospitalSearchDict["Latitude"].string
        }else
        {
            hospitalModel.Latitude = String(describing: hospitalSearchDict["Latitude"].doubleValue)
        }
        if  hospitalSearchDict["Longitude"].string != nil {
            hospitalModel.Longitude = hospitalSearchDict["Longitude"].string
        }
        else
        {
            hospitalModel.Longitude = String(describing: hospitalSearchDict["Longitude"].doubleValue)
        }
        delegate?.SuccessHospitalListCompletData(ListData: hospitalModel)
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK:- Hospital List View Protocol
extension HospitalListView:HospitalListProtocol
{
    func SuccessHospitalListProtocol(jsonArray:JSON)
    {
        searchFilterArray.removeAll()
        if (!(jsonArray["GetCollectionCentersList"]["ResponseDetails"].arrayValue.isEmpty))
        {
            searchFilterArray = jsonArray["GetCollectionCentersList"]["ResponseDetails"].arrayValue
            self.lblListNotAvailable.isHidden = true
            searchTableView.reloadData()
            return
        }
        else
        {
            self.lblListNotAvailable.isHidden = false
            searchTableView.isHidden = true
            self.lblListNotAvailable.text = jsonArray["GetCollectionCentersList"]["ResponseDetails"]["ErrorDescription"].string
        }
    }
    func FailedHospitalListProtocol()
    {
        searchFilterArray.removeAll()
        searchTableView.isHidden = true
        self.lblListNotAvailable.text = StringList.LifeLine_Internet_Error_Message.rawValue
    }
}

