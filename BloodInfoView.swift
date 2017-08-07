//
//  BloodInfoView.swift
//  lifeline
//
//  Created by AppleMacBook on 21/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

protocol ProtocolBloodInfo
{
    func SuccessProtocolBloodInfo(valueSent: String,CheckString:String)
    func FailureProtocolBloodInfo(valueSent: String)
}

class BloodInfoView: UIViewController {

    var delegate:ProtocolBloodInfo?

    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var pickerViewBloodInfo: UIPickerView!

    var pickercheck = String()
    var pickerArray = [String]()
    var bloodInfoString = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        labelHeading.text = bloodInfoString
        // Do any additional setup after loading the view.
    }
    //MARK:- btnDoneTapped
    @IBAction func btnDoneTapped(_ sender: Any) {
        let row = pickerViewBloodInfo.selectedRow(inComponent: 0);
        pickerView(pickerViewBloodInfo, didSelectRow: row, inComponent: 0)
        delegate?.SuccessProtocolBloodInfo(valueSent: self.pickercheck,CheckString:bloodInfoString)
        self.dismiss(animated: true, completion: nil)
    }
//MARK:- btnCancelTapped
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        }
}
extension BloodInfoView : UIPickerViewDataSource,UIPickerViewDelegate
{
    //MARK:- DataSourece
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.pickerArray.count
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return pickerArray[row]
    }
    //MARK:- Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        pickercheck = self.pickerArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
    }
}
