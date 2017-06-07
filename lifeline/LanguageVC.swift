//
//  LanguageVC.swift
//  lifeline
//
//  Created by Anjali on 05/06/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class LanguageVC: UIViewController {

    @IBOutlet weak var tableObj: UITableView! // tblView
    var langaugeTitle : [String] = ["English", "हिंदी", "ಕನ್ನಡ", "தமிழ்", "తెలుగు"]
    var langaugeSubtitle: [String] = ["English", "Hindi", "Kannada", "Tamil", "Telugu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()

    }
    
    @IBAction func BackToHome(_ sender: Any)
    {
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
        self.present(storyObj!, animated: true, completion: nil)
    }
}

extension LanguageVC : UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return langaugeTitle.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: LanguageTableCell = (self.tableObj.dequeueReusableCell(withIdentifier: "Cell")! as! LanguageTableCell)
        cell.Lang?.text = langaugeTitle[indexPath.row]
        cell.subTitle?.text = langaugeSubtitle[indexPath.row]
        
        return cell
    }
}

extension LanguageVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = self.tableObj.cellForRow(at: indexPath) as! LanguageTableCell
        cell.accessoryType = UITableViewCellAccessoryType.checkmark

        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to change your language", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = self.tableObj.cellForRow(at: indexPath) as! LanguageTableCell
        cell.accessoryType = UITableViewCellAccessoryType.none
    }
}
