//
//  RevalListView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class RevalListView: UIViewController
{
    @IBOutlet weak var menuTableView: UITableView!
    var menuArray = [String]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
         menuArray = ["myProfile","FAQ","changePassword"]
        // Do any additional setup after loading the view.
    }
}
extension RevalListView:UITableViewDelegate,UITableViewDataSource
{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return menuArray.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellString = menuArray[indexPath.row]
            let cell:UITableViewCell = (self.menuTableView.dequeueReusableCell(withIdentifier: cellString )! as UITableViewCell)
            return cell
        }
}
