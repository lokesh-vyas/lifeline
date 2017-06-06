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

extension LanguageVC : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
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
            print("Default Cell..")
        }
        
    }
    
    func reloadVC() {
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
    }

    
}
