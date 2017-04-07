//
//  MyRequestClose.swift
//  lifeline
//
//  Created by iSteer on 25/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyRequestClose: UIViewController {
    
    @IBOutlet weak var txtThankNote: UITextView!
    @IBOutlet weak var viewCloseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewCloseRequest: UIView!
    @IBOutlet weak var viewDontedSwitch: UIView!
    var MyRequestCloseJSON :JSON = []
    var StringForCheckView = String()
    var HasDonated:String?
    var DonorID = String()
    @IBOutlet weak var constraintDontaedSwitch: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if StringForCheckView == "MyRequest"
        {
            self.viewDontedSwitch.isHidden = true
            UIView.animate(withDuration: Double(0.1), animations: {
                self.constraintDontaedSwitch.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else
        {
            HasDonated = "YES"
            self.viewDontedSwitch.isHidden = false
            UIView.animate(withDuration: Double(0.1), animations: {
                self.constraintDontaedSwitch.constant = 36
                self.view.layoutIfNeeded()
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyRequestClose.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MyRequestClose.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- keyboard Appear / DisAppear
    func keyboardWillShow(notification: NSNotification) {
        
        UIView.animate(withDuration: Double(0.5), animations: {
            self.viewCloseTopConstraint.constant = -70
            self.view.layoutIfNeeded()
        })
    }
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.viewCloseTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    //MARK:- switchHasDonated
    @IBAction func switchHasDonated(_ sender: UISwitch)
    {
        if sender.isOn
        {
            HasDonated = "YES"
        }
        else
        {
            HasDonated = "NO"
        }
    }
    //MARK:- btnCancelTapped
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- btnSubmitTapped
    @IBAction func btnSubmitTapped(_ sender: Any)
    {
        self.view.endEditing(true)
        if self.txtThankNote.text.characters.count == 0
        {
            self.txtThankNote.text = ""
        }
        if StringForCheckView == "MyRequest"
        {
            self.SubmitForMyRquest()
        }
        else
        {
            self.SubmitForMyDonor()
        }
    }
    //MARK:- SubmitForMyRquest
    func SubmitForMyDonor()
    {
        let RequestID = MyRequestCloseJSON["RequestID"]
        let customer : Dictionary = ["RequestStatusUpdateReqest":["RequestDetails":["RequestID":String(describing: RequestID),"Status":"Open","DonorsDetails":[["DonationId":DonorID,"HasDonated":HasDonated!,"DonatedOn":Util.SharedInstance.currentDateChangeForServer(),"ThankYouNote":self.txtThankNote.text!]]]]]
        print(customer)
        HudBar.sharedInstance.showHudWithMessage(message: "Please wait..", view: self.view)
        MyRequestInteractor.SharedInstance.delegate = self
        MyRequestInteractor.SharedInstance.MyRequestClose(params: customer)
    }
    
    //MARK:- SubmitForMyRquest
    func SubmitForMyRquest()
    {
        var myNewDictArray = [Dictionary<String, String>]()
        let RequestID = MyRequestCloseJSON["RequestID"]
        if (MyRequestCloseJSON["DonorsDetails"].string != nil)
        {
            var myRequestArray = MyRequestCloseJSON["DonorsDetails"]["DonorDetails"]
            if (myRequestArray.dictionary) != nil
            {
                myRequestArray = JSON.init(arrayLiteral: myRequestArray)
            }
            for (i, _) in myRequestArray.enumerated()
            {
                let donorID = myRequestArray[i]["DonationId"].string
                myNewDictArray.append(["DonationId":donorID!,"HasDonated":"","DonatedOn":Util.SharedInstance.currentDateChangeForServer(),"ThankYouNote":self.txtThankNote.text!
                    ])
            }
        }
        let customer : Dictionary = ["RequestStatusUpdateReqest":["RequestDetails":["RequestID":String(describing: RequestID),"Status":"Close","DonorsDetails":myNewDictArray]]]
        HudBar.sharedInstance.showHudWithMessage(message: "Please wait..", view: self.view)
        MyRequestInteractor.SharedInstance.delegate = self
        MyRequestInteractor.SharedInstance.MyRequestClose(params: customer)
    }
}
extension MyRequestClose:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        if (touch.view?.isDescendant(of: viewCloseRequest))!
        {
            return false
        }
        self.dismiss(animated: true, completion: nil)
        return true
    }
}
//MARK:- MyRequestProtocol
extension MyRequestClose:MyRequestProtocol
{
    func SuccessMyRequest(JSONResponse: JSON, Sucess: Bool)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MyRequestServiceCallUpdate"), object: nil)
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Your Request has been closed", view: self.view)
        if StringForCheckView == "MyRequest" {
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
            {
                let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.present(SWRevealView, animated: true, completion: nil)
        })
        }
    }
    func FailMyRequest(Response:String)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast("No Internet Connection, please check your Internet Connection", duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast("Unable to access server, please try again later", duration: 3.0, position: .bottom)
        }
    }
}
