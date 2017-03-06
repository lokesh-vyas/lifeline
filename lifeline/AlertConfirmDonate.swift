//
//  AlertConfirmDonate.swift
//  lifeline
//
//  Created by Apple on 28/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON
import Toast_Swift

class AlertConfirmDonate: UIViewController {

    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var subViewAlert: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AlertConfirmDonateInteractor.sharedInstance.delegate = self
 
    }

    @IBAction func btnPreferredDateTapped(_ sender: Any) {
        
        print("DatePicker Should come")
        
    }
    
    @IBAction func btnDonateTapped(_ sender: Any) {
        print("  WS must be called")
        let url = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ConfirmDonate"
        let collectedParameters = ["ConfirmDonateRequest":
                                        ["ConfirmDonateDetails":
                                            ["LoginID": "114177301473189791455",
                                             "PrefferedDateTime": "2015-08-10 13:03:06",
                                             "ID": "1",
                                             "TypeOfOrg":"1",
                                             "Comment": "Comment data"
                                            ]]]
        
        AlertConfirmDonateInteractor.sharedInstance.confirmsDonate(urlString: url, params: collectedParameters)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AlertConfirmDonate : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: subViewAlert))! {
            return true
        }
        dismiss(animated: true, completion: nil)
        return false
    }
}

extension AlertConfirmDonate : AlertConfirmDonateProtocol {
    func successConfirmDonate(jsonArray: JSON) {
        print("****SUCCESS****", jsonArray)
        self.view.makeToast("Requested Details Submited Sucessfully")
        
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealView, animated: true, completion: nil)
    //    self.navigationController?.present(SWRevealView, animated: true, completion: nil)
//        let reachHome = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//        let nav = UINavigationController(rootViewController: reachHome)
//        self.navigationController?.present(nav, animated: true, completion: nil)
        
        }
    func failedConfirmDonate() {
        print("****FAILED****")
    }
}
