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
    func SuccessProtocolCalendar(valueSent: String)
    func FailureProtocolCalendar(valueSent: String)
}

class CalendarView: UIViewController {

    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var pickerSelectDate: UIDatePicker!
    
    var delegate:ProtocolCalendar?
    var dateFormatter = DateFormatter()
    var dateString = String()
    var calendar = UIDatePicker()
    var calenderHeading = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSelectDate.maximumDate = calendar.maximumDate
        pickerSelectDate.minimumDate = calendar.minimumDate
        pickerSelectDate.datePickerMode = calendar.datePickerMode
        pickerSelectDate.backgroundColor = UIColor.white
        labelHeading.text = calenderHeading
        print("labelheading",labelHeading.text!)

        // Do any additional setup after loading the view.
    }

    @IBAction func btnDoneTapped(_ sender: Any) {
        let strDate = dateFormatter.string(from: pickerSelectDate.date)
        dateString = strDate
        print("string",dateString)
        delegate?.SuccessProtocolCalendar(valueSent: self.dateString)
        delegate?.FailureProtocolCalendar(valueSent: "Fail")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
