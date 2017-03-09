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
    @IBOutlet weak var btnPreferredDateTime: UIButton!
    var preferredDateTime : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        AlertConfirmDonateInteractor.sharedInstance.delegate = self
 
    }

    @IBAction func btnPreferredDateTapped(_ sender: Any) {
        
        print("DatePicker Should come")
        let preferredDateAlert: CalendarView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView") as! CalendarView
        preferredDateAlert.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
        preferredDateAlert.dateFormatter = dateFormatter
        preferredDateAlert.calenderHeading = "Confirm Your Date"
        preferredDateAlert.calendar.minimumDate = Date() as Date
        preferredDateAlert.calendar.datePickerMode = UIDatePickerMode.dateAndTime
        preferredDateAlert.modalPresentationStyle = .overCurrentContext
        preferredDateAlert.view.backgroundColor =  UIColor.clear
        self.present(preferredDateAlert, animated: true, completion: nil)

        
        
    }
    
    @IBAction func btnDonateTapped(_ sender: Any) {
        print("  WS must be called")
        
        if MarkerData.SharedInstance.PreferredDateTime != "null" || preferredDateTime != nil {
        HudBar.sharedInstance.showHudWithMessage(message: "Submitting...", view: self.view)
        let url = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ConfirmDonate"
        //FIXME:- the request Body
            let IDtoBeSent = (MarkerData.SharedInstance.oneRequestOfDonate["CID"] != nil) ? (MarkerData.SharedInstance.oneRequestOfDonate["CID"])! : (MarkerData.SharedInstance.markerData["ID"]!)
            let CommentText = (MarkerData.SharedInstance.CommentLines != nil) ? MarkerData.SharedInstance.CommentLines! : self.txtViewComment.text!
        let collectedParameters = ["ConfirmDonateRequest":
                                        ["ConfirmDonateDetails":
                                            ["LoginID": "114177301473189791455",
                                             "PrefferedDateTime": preferredDateTime!,
                                                "ID": IDtoBeSent,
                                             "TypeOfOrg":"\(MarkerData.SharedInstance.markerData["TypeOfOrg"]!)",
                                             "Comment": CommentText
                                            ]]]
        
        AlertConfirmDonateInteractor.sharedInstance.confirmsDonate(urlString: url, params: collectedParameters)
        } else {
            let alert = UIAlertController(title: "Missing", message: "Preferred Date & Time is Missing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)

        }
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
        let when = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(SWRevealView, animated: true, completion: nil)
        }
        )
        
        }
    func failedConfirmDonate() {
        print("****FAILED****")
        
    }
}

extension AlertConfirmDonate : ProtocolCalendar {
    
    func SuccessProtocolCalendar(valueSent: String, CheckString: String) {
        print("valueSent :\(valueSent) && CheckString :\(CheckString)")
        self.btnPreferredDateTime.setTitle(valueSent, for: .normal)
        let dateForCamp = Util.SharedInstance.preferredDateToCamp()
        preferredDateTime = (MarkerData.SharedInstance.PreferredDateTime != nil) ? (MarkerData.SharedInstance.PreferredDateTime!) : dateForCamp
    }
    func FailureProtocolCalendar(valueSent: String) {
        print("CALENDER is FAILED")
    }
}
