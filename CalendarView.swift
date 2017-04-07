//
//  CalendarView.swift
//  lifeline
//
//  Created by AppleMacBook on 21/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
protocol ProtocolCalendar
{
    func SuccessProtocolCalendar(valueSent: String,CheckString:String)
    func FailureProtocolCalendar(valueSent: String)
}

class CalendarView: UIViewController {

    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var pickerSelectDate: UIDatePicker!
    @IBOutlet weak var btnCancel: UIButton!
    
    var delegate:ProtocolCalendar?
    var dateFormatter = DateFormatter()
    var calendar = UIDatePicker()
    var calenderHeading = String()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if calenderHeading == "Last Donation Date"
        {
            btnCancel.setTitle("Clear", for: .normal)
        }
        labelHeading.text = calenderHeading
        pickerSelectDate.maximumDate = calendar.maximumDate
        pickerSelectDate.minimumDate = calendar.minimumDate
        pickerSelectDate.datePickerMode = calendar.datePickerMode
        pickerSelectDate.backgroundColor = UIColor.white
        
    }
   //MARK:- btnSelectTapped
    @IBAction func btnSelectTapped(_ sender: Any) {
        delegate?.SuccessProtocolCalendar(valueSent: dateFormatter.string(from: pickerSelectDate.date),CheckString: calenderHeading)
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- btnCancelTapped
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if calenderHeading == "Last Donation Date"
        {
           delegate?.FailureProtocolCalendar(valueSent:"Clear")
        }
       
    }
}
