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
        let InternalCheck:String = UserDefaults.standard.value(forKey: "LoginInformation")! as! String
        if InternalCheck == "Internal"
        {
            menuArray = ["myProfile","changePassword","share","FAQ"]
        }else
        {
            menuArray = ["myProfile","share","FAQ"]
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let InternalCheck:String = UserDefaults.standard.value(forKey: "LoginInformation")! as! String
        if InternalCheck == "Internal"
        {
            if indexPath.row == 2
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShareApplicationURL"), object: nil)
            }
        }else
        {
            if indexPath.row == 1
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShareApplicationURL"), object: nil)
            }
        }
     }
}
