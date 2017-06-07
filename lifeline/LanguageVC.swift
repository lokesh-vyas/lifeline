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
    var langCode: [String] = ["en","hi","kn-IN","ta-IN","te-IN"]
    var indexOfSelectedLangauge = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lang = MultiLanguage.currentAppleLanguageFull()
        print(lang)
        
        for i in 0..<langCode.count {
            if langCode[i] == lang
            {
                indexOfSelectedLangauge = i
            }
        }
        self.navigationController?.completelyTransparentBar()
        
    }
    
    @IBAction func BackToHome(_ sender: Any)
    {
        let storyObj = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
        self.present(storyObj!, animated: true, completion: nil)
    }
    //MARK:- Reload VC
    func reloadVC() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
    }
    func tableReloadData()
    {
        self.tableObj.reloadData()
    }
    func langaugeSelectFromTable(indexPath:Int)
    {
        switch indexPath {
        case 0:
            MultiLanguage.setAppleLAnguageTo(lang: "en")
            reloadVC()
            break
            
        case 1 :
            MultiLanguage.setAppleLAnguageTo(lang: "hi")
            reloadVC()
            break
            
        case 2 :
            MultiLanguage.setAppleLAnguageTo(lang: "kn-IN")
            reloadVC()
            break
            
        case 3 :
            MultiLanguage.setAppleLAnguageTo(lang: "ta-IN")
            reloadVC()
            break
            
        case 4 :
            MultiLanguage.setAppleLAnguageTo(lang: "te-IN")
            reloadVC()
            break
            
        default:
            MultiLanguage.setAppleLAnguageTo(lang: "en")
            reloadVC()
        }
    }
}
//MARK:- UITableViewDataSource
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
        cell.accessoryType = UITableViewCellAccessoryType.none
        if indexPath.row == indexOfSelectedLangauge {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell
    }
    
}
//MARK:- UITableViewDelegate
extension LanguageVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = self.tableObj.cellForRow(at: indexPath) as! LanguageTableCell
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to change your language", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:
        { _ in
                self.langaugeSelectFromTable(indexPath: indexPath.row)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            _ in
            self.tableReloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = self.tableObj.cellForRow(at: indexPath) as! LanguageTableCell
        cell.accessoryType = UITableViewCellAccessoryType.none
    }
    
}
