//
//  MarkersListView.swift
//  lifeline
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MarkersListView: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var listMarkers = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblView.contentInset = UIEdgeInsetsMake(-35, 0.0, +195, 0.0)
        if SingleTon.SharedInstance.noMarkers == true {
            tblView.isHidden = true
        }
    }

    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


extension MarkersListView : UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return listMarkers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier:String = "HospitalListCell"
        var cell:HospitalListCell? = tblView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HospitalListCell
        if (cell == nil)
        {
            var nib:Array = Bundle.main.loadNibNamed("HospitalListCell", owner: self, options: nil)!
            cell = nib[0] as? HospitalListCell
        }
        cell?.lblHospitalName.text = String(describing: listMarkers[indexPath.row]["Name"]!)
        cell?.lblCityName.text = String(describing: listMarkers[indexPath.row]["WorkingHours"]!)

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
}

extension MarkersListView : UISearchBarDelegate {
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("You're trying to search something...")
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }

}
