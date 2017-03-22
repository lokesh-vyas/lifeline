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
import UserNotifications


class AlertConfirmDonate: UIViewController {
    
    @IBOutlet weak var txtViewComment: UITextView!
    @IBOutlet weak var subViewAlert: UIView!
    @IBOutlet weak var btnPreferredDateTime: UIButton!
    @IBOutlet weak var alertBoxTopConstraint : NSLayoutConstraint?
    
    var preferredDateTime : String?
    var lastSentDate : String?
    var IDtoBeSent:String?
    var TypeLocalNotificationIndividual : String?
    
    
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
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
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
            
            
            let TypeOfOrg:String
            if MarkerData.SharedInstance.isIndividualAPN == false || MarkerData.SharedInstance.isNotIndividualAPN == false {
                IDtoBeSent = String(describing: (MarkerData.SharedInstance.oneRequestOfDonate["CID"] != nil) ? (MarkerData.SharedInstance.oneRequestOfDonate["CID"])! : (MarkerData.SharedInstance.markerData["ID"]!))
                if MarkerData.SharedInstance.oneRequestOfDonate["CID"] != nil {
                    TypeOfOrg =  MarkerData.SharedInstance.oneRequestOfDonate["CTypeOfOrg"]! as! String
                    TypeLocalNotificationIndividual = "11"
                } else {
                    TypeOfOrg =  MarkerData.SharedInstance.markerData["TypeOfOrg"]! as! String
                    
                    if String(describing: MarkerData.SharedInstance.markerData["TypeOfOrg"]!) == "2" {
                        TypeLocalNotificationIndividual = "12" // Camp
                    }
                    if String(describing: MarkerData.SharedInstance.markerData["TypeOfOrg"]!) == "1" {
                        TypeLocalNotificationIndividual = "13" // Hospital
                    }
                    
                }
                
            } else {
                if MarkerData.SharedInstance.isAPNCamp == true {
                    IDtoBeSent = String(describing: MarkerData.SharedInstance.APNResponse["CampaignID"]!)
                    TypeOfOrg = "2"
                } else {
                    IDtoBeSent = String(describing: MarkerData.SharedInstance.APNResponse["RequestID"]!)
                    TypeOfOrg = "3"
                }
            }
            
            //FIXME:- the request Body
            let CommentText = self.txtViewComment.text!//(MarkerData.SharedInstance.CommentLines != nil) ? MarkerData.SharedInstance.CommentLines! : self.txtViewComment.text!
            let collectedParameters = ["ConfirmDonateRequest":
                ["ConfirmDonateDetails":
                    ["LoginID": UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!,
                     "PrefferedDateTime": preferredDateTime!,
                     "ID": IDtoBeSent,
                     "TypeOfOrg":TypeOfOrg,
                     "Comment": CommentText
                    ]]]
            
            var reminder = Util.SharedInstance.dateStringToDateForNotification(dateString: Util.SharedInstance.dateForReminder(dateString: preferredDateTime!))
            reminder.addTimeInterval(_: -60)
            self.scheduleNotification(at:reminder)
            AlertConfirmDonateInteractor.sharedInstance.confirmsDonate(urlString: URLList.CONFIRM_DONATE.rawValue, params: collectedParameters)
            
        } else {
            let alert = UIAlertController(title: "Missing", message: "Preferred Date & Time is Missing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        HudBar.sharedInstance.hideHudFormView(view: ConfirmDonate().view)
        HudBar.sharedInstance.hideHudFormView(view: IndividualConfirmDonate().view)
    }
    
    func scheduleNotification(at date: Date) {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            content.title = "Blood Donation"
            content.body = "Reminder for Blood Donation"
            content.userInfo = [ "Title":"\(content.title)", "Body":"\(content.body)", "ID":"\(IDtoBeSent!)","Type":"\(TypeLocalNotificationIndividual!)"]
            content.sound = UNNotificationSound.default()
            let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Uh oh! We had an error: \(error)")
                }
            }
        } else {
            // Fallback on earlier versions
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.alertTitle = "Blood Donation"
            notification.alertBody = "Reminder for Blood Donation"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.timeZone = NSTimeZone.default
            UIApplication.shared.scheduleLocalNotification(notification)

        }
        
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
            HudBar.sharedInstance.hideHudFormView(view: self.view)
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
        btnPreferredDateTime.setTitle(valueSent, for: .normal) //15/03/2017 17:52
        
        let dateForCamp = Util.SharedInstance.preferredDateToCamp(selectedDate: valueSent) //yyyy-MM-dd HH:mm:ss//sending to server
        
        //To send in the body //FIXME:- not changed
        MarkerData.SharedInstance.PreferredDateTime = valueSent
        MarkerData.SharedInstance.CommentLines = txtViewComment.text
        
        preferredDateTime = (MarkerData.SharedInstance.PreferredDateTime != nil) ? Util.SharedInstance.preferredDateToCamp(selectedDate: MarkerData.SharedInstance.PreferredDateTime!) : dateForCamp
        
        
        
        
    }
    func FailureProtocolCalendar(valueSent: String) {
        print("CALENDAR is FAILED")
    }
}
