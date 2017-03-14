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
    @IBOutlet weak var alertBoxTopConstraint : NSLayoutConstraint?
    
    var preferredDateTime : String?
    var lastSentDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         NotificationCenter.default.addObserver(self, selector: #selector(AlertConfirmDonate.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        
        //FIXME:- preferred date
        AlertConfirmDonateInteractor.sharedInstance.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(RequestView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RequestView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if MarkerData.SharedInstance.CommentLines != nil && MarkerData.SharedInstance.PreferredDateTime != nil {
            
            self.btnPreferredDateTime.setTitle(MarkerData.SharedInstance.PreferredDateTime, for: .normal)
            self.txtViewComment.text = MarkerData.SharedInstance.CommentLines
            preferredDateTime = MarkerData.SharedInstance.PreferredDateTime
        }
   }
    //MARK:- PushNotificationView
    func PushNotificationView(_ notification: NSNotification)
    {
        let dict = notification.object as! Dictionary<String, Any>
        
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .overCurrentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
    }
    
    //MARK:- Keyboard Appear/Diappear
    func keyboardWillShow(notification:NSNotification)
    {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.alertBoxTopConstraint?.constant = -60
            self.view.layoutIfNeeded()
        })
    }
    func keyboardWillHide(notification:NSNotification){
        
        UIView.animate(withDuration: Double(0.5), animations: {
            self.alertBoxTopConstraint?.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
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
        
        if preferredDateTime != nil {
        HudBar.sharedInstance.showHudWithMessage(message: "Submitting...", view: self.view)
     //   let url = "http://demo.frontman.isteer.com:8284/services/DEV-LifeLine.ConfirmDonate"
            let IDtoBeSent:String
            let TypeOfOrg:String
            if MarkerData.SharedInstance.isIndividualAPN == false || MarkerData.SharedInstance.isNotIndividualAPN == false
            {
                  IDtoBeSent =
                    String(describing: (MarkerData.SharedInstance.oneRequestOfDonate["CID"] != nil) ? (MarkerData.SharedInstance.oneRequestOfDonate["CID"])! : (MarkerData.SharedInstance.markerData["ID"]!))
                
                if MarkerData.SharedInstance.oneRequestOfDonate["CID"] != nil {
                    TypeOfOrg =  MarkerData.SharedInstance.markerData["CTypeOfOrg"]!
                    
                } else {
                    TypeOfOrg =  MarkerData.SharedInstance.markerData["TypeOfOrg"]!
                }
                
            }else
            {
                if MarkerData.SharedInstance.isAPNCamp == true
                {
                    IDtoBeSent =
                        String(describing: MarkerData.SharedInstance.APNResponse["CampaignID"]!)
                    TypeOfOrg = "2"
                }else
                {
                    IDtoBeSent =
                        String(describing: MarkerData.SharedInstance.APNResponse["RequestID"]!)
                    TypeOfOrg = "3"
                }
            }
            
        //FIXME:- the request Body
           
            let CommentText = (MarkerData.SharedInstance.CommentLines != nil) ? MarkerData.SharedInstance.CommentLines! : self.txtViewComment.text!
        let collectedParameters = ["ConfirmDonateRequest":
                                        ["ConfirmDonateDetails":
                                            ["LoginID": UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!,
                                             "PrefferedDateTime": preferredDateTime!,
                                             "ID": IDtoBeSent,
                                             "TypeOfOrg":TypeOfOrg,
                                             "Comment": CommentText
                                            ]]]
        
        AlertConfirmDonateInteractor.sharedInstance.confirmsDonate(urlString: URLList.CONFIRM_DONATE.rawValue, params: collectedParameters)
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
        btnPreferredDateTime.setTitle(valueSent, for: .normal) //15/03/2017 03:14
        
        let dateForCamp = Util.SharedInstance.preferredDateToCamp(selectedDate: valueSent) //yyyy-MM-dd HH:mm:ss
        
        //To send in the body //FIXME:- not changed
        preferredDateTime = (MarkerData.SharedInstance.PreferredDateTime != nil) ? Util.SharedInstance.preferredDateToCamp(selectedDate: MarkerData.SharedInstance.PreferredDateTime!) : dateForCamp
        
        MarkerData.SharedInstance.CommentLines = txtViewComment.text
        MarkerData.SharedInstance.PreferredDateTime = valueSent
        
    }
    func FailureProtocolCalendar(valueSent: String) {
        print("CALENDER is FAILED")
    }
}
