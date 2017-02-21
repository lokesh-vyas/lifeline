//
//  ProfileView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class ProfileView: UIViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var nameTextField: FloatLabelTextField!
    @IBOutlet weak var emailTextField: FloatLabelTextField!
    @IBOutlet weak var contactNumberText: FloatLabelTextField!
    @IBOutlet weak var homeAddressText: FloatLabelTextField!
    @IBOutlet weak var homePINText: FloatLabelTextField!
    @IBOutlet weak var homeCityText: FloatLabelTextField!
    @IBOutlet weak var workAddressText: FloatLabelTextField!
    @IBOutlet weak var workPINText: FloatLabelTextField!
    @IBOutlet weak var workCityText: FloatLabelTextField!
    @IBOutlet weak var profileScrollView: UIScrollView!
    
    var DOBstring = String()

    @IBOutlet var btnDOBOutlet: UIButton!
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        profileScrollView.contentSize = CGSize(width: self.view.frame.width, height: 1300)
    }
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
    }
    //MARK:- Back Button
    @IBAction func BackButton(_ sender: Any)
    {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    //MARK:- BloodGroupAction
    @IBAction func BloodGroupAction(_ sender: Any)
    {
    }
    //MARK:- DateOfBirthAction
    @IBAction func DOBAction(_ sender: Any) {
        
        let viewCalendar: CalendarView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView") as! CalendarView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        viewCalendar.delegate = self
        viewCalendar.dateFormatter = dateFormatter
        let headingString = "Confirm Your Date"
        viewCalendar.calenderHeading = headingString
        viewCalendar.calendar.maximumDate = Date() as Date
        viewCalendar.modalPresentationStyle = .overCurrentContext
        viewCalendar.view.backgroundColor =  UIColor.clear
        viewCalendar.calendar.datePickerMode = UIDatePickerMode.date
        self.present(viewCalendar, animated: true, completion: nil)
    }
    //MARK:- LastDonationDate
    @IBAction func lastDonationDate(_ sender: Any)
    {
    }
    //MARK:- HomeGoogleMapAction
    @IBAction func homeGoogleMapAction(_ sender: Any)
    {
    }
    //MARK:- WorkGoogleMapAction
    @IBAction func workGoogleMapAction(_ sender: Any)
    {
    }
    //MARK:- ProfileSubmitAction
    @IBAction func profileSubmitAction(_ sender: Any)
    {
    }
}
extension ProfileView:ProtocolCalendar
{
    
    func SuccessProtocolCalendar(valueSent: String)
    {
        self.DOBstring = valueSent
        btnDOBOutlet.setTitle(self.DOBstring, for: .normal)
        print("whenYouNeedString",self.DOBstring)
    }
    
    func FailureProtocolCalendar(valueSent: String)
    {
        print("Try Again")
    }
}
