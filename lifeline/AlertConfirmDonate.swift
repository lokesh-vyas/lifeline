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
        let preferredDateAlert: CalendarView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView") as! CalendarView
        preferredDateAlert.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        preferredDateAlert.dateFormatter = dateFormatter
        
        preferredDateAlert.calenderHeading = "Confirm Your Date"
        preferredDateAlert.calendar.minimumDate = Date() as Date
        preferredDateAlert.calendar.datePickerMode = UIDatePickerMode.date
        preferredDateAlert.modalPresentationStyle = .overCurrentContext
        preferredDateAlert.view.backgroundColor =  UIColor.clear
        self.present(preferredDateAlert, animated: true, completion: nil)

        
        
    }
    
    @IBAction func btnDonateTapped(_ sender: Any) {
        print("  WS must be called")
        let url = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ConfirmDonate"
        //FIXME:- the request Body
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
        
        }
    func failedConfirmDonate() {
        print("****FAILED****")
    }
}

extension AlertConfirmDonate : ProtocolCalendar {
    
    func SuccessProtocolCalendar(valueSent: String, CheckString: String) {
        print("valueSent :\(valueSent) && CheckString :\(CheckString)")
    }
    func FailureProtocolCalendar(valueSent: String) {
        print("CALENDER is FAILED")
    }
}
