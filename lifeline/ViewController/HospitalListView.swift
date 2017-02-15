//
//  HospitalListView.swift
//  lifeline
//
//  Created by iSteer on 14/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class HospitalListView: UIViewController {

    @IBOutlet weak var searchBarText: UISearchBar!
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        searchBarText.becomeFirstResponder()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.completelyTransparentBar()
        
        // Do any additional setup after loading the view.
    }
}
extension HospitalListView:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        // Do some search stuff
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
      self.dismiss(animated: true, completion: nil)
    }
}

