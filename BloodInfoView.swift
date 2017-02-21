//
//  BloodInfoView.swift
//  lifeline
//
//  Created by AppleMacBook on 21/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnDoneTapped(_ sender: Any) {
        let row = pickerViewBloodInfo.selectedRow(inComponent: 0);
        print("value %d", row)
        pickerView(pickerViewBloodInfo, didSelectRow: row, inComponent: 0)
        delegate?.SuccessProtocolBloodInfo(valueSent: self.pickercheck)
        delegate?.FailureProtocolBloodInfo(valueSent: "Fail")
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
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
        
        print("pickercheck row",row)
        pickercheck = self.pickerArray[row]
        
    }
}
