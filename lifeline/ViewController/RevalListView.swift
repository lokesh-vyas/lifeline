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
            menuArray = ["myProfile","Notifications","changePassword","share","Language","FAQ"]
            //menuArray = ["myProfile","changePassword","share","Language","FAQ"]
        }else
        {
           menuArray = ["myProfile","Notifications","share","Language","FAQ"]
            //menuArray = ["myProfile","share","Language","FAQ"]
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
            if indexPath.row == 1
            {
                let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "MyNotificationView")
                let nav = UINavigationController(rootViewController: storyObj!)
                self.present(nav, animated: true, completion: nil)
                
            }
            if indexPath.row == 3
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShareApplicationURL"), object: nil)
            }
            if indexPath.row == 4
            {
                let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "LanguageView")
                let nav = UINavigationController(rootViewController: storyObj!)
                self.present(nav, animated: true, completion: nil)
            }
            if indexPath.row == 5
            {
                let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "FAQView")
                let nav = UINavigationController(rootViewController: storyObj!)
                self.present(nav, animated: true, completion: nil)

            }
        }else
        {
            if indexPath.row == 1
            {
                let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "MyNotificationView")
                let nav = UINavigationController(rootViewController: storyObj!)
                self.present(nav, animated: true, completion: nil)

            }
            if indexPath.row == 2
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShareApplicationURL"), object: nil)
            }
            if indexPath.row == 3
            {
                let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "LanguageView")
                let nav = UINavigationController(rootViewController: storyObj!)
                self.present(nav, animated: true, completion: nil)
            }
            if indexPath.row == 4
            {
                let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "FAQView")
                let nav = UINavigationController(rootViewController: storyObj!)
                self.present(nav, animated: true, completion: nil)
            }
        }
        
     }
}
