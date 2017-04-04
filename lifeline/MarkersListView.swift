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
        if SingleTon.SharedInstance.noMarkers == true {
            tblView.isHidden = true
        }
        var arrayName = [String]()
        var arrayTimings = [String]()
        
        for (i, _) in listMarkers.enumerated() {
            arrayName[i] = String(describing: listMarkers[i]["Name"]!)
            arrayTimings[i] = String(describing: listMarkers[i]["WorkingHours"]!)
        }
        let temp = Set(arrayName)
        print("------\(temp)-----")
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
        
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        cell.textLabel?.text = String(describing: listMarkers[indexPath.row]["Name"]!)
        cell.detailTextLabel?.text = String(describing: listMarkers[indexPath.row]["WorkingHours"]!)
        
        return cell
    }
}

extension MarkersListView : UITableViewDelegate {
    
}

extension MarkersListView : UISearchBarDelegate {
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("You're trying to search something...")
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }

}
