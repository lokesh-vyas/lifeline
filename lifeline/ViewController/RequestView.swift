//
//  RequestView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

protocol ProtocolBloodInfo
{
    func SuccessProtocolBloodInfo(valueSent: String)
    func FailureProtocolBloodInfo(valueSent: String)
}


class RequestView: UIViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var txtFieldPatientName: FloatLabelTextField!
    @IBOutlet weak var txtFieldContactPerson: FloatLabelTextField!
    @IBOutlet weak var txtFieldContactNumber: FloatLabelTextField!
    @IBOutlet weak var txtFieldHospitalBloodBankName: FloatLabelTextField!
    @IBOutlet weak var txtFieldDoctorName: FloatLabelTextField!
    @IBOutlet weak var txtFieldHospitalBloodBankContactNumber: FloatLabelTextField!
    @IBOutlet weak var txtFieldHospitalBloodBankAddress: FloatLabelTextField!
    @IBOutlet weak var txtFieldHospitalBloodBankAddressLandMark: FloatLabelTextField!
    @IBOutlet weak var txtFieldHospitalBloodBankAddressCity: FloatLabelTextField!
    @IBOutlet weak var txtFieldHospitalBloodBankAddressPINCode: FloatLabelTextField!
    @IBOutlet weak var txtViewPersonalAppeal: UITextView!
    
    @IBOutlet var switchForAppeal: UISwitch!
    @IBOutlet weak var btnBloodUnit: UIButton!
    @IBOutlet weak var btnBloodGroup: UIButton!
    @IBOutlet weak var btnWhenYouNeed: UIButton!
    @IBOutlet weak var btnWhatYouNeed: UIButton!
    
    @IBOutlet weak var imgSocialShare: UIImageView!
    
    //MARK:- String
    var buttonupdate = String()
    var checkdatafromprevious:String?
    var whenYouNeedString:String?
    //MARK:- Arrays
    let bloodGroupArray = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodUnitArray = ["1","2","3","4","5","6","7","8","9","10"]
    let whatneedArray = ["Blood","Platelets","Plasma"]

    
    @IBOutlet var scrollViewRequest: UIScrollView!
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldPatientName.delegate = self
        txtFieldContactPerson.delegate = self
        txtFieldContactNumber.delegate = self
        txtFieldHospitalBloodBankName.delegate = self
        txtFieldDoctorName.delegate = self
        txtFieldHospitalBloodBankContactNumber.delegate = self
        txtFieldHospitalBloodBankAddressCity.delegate = self
        txtFieldHospitalBloodBankAddressLandMark.delegate = self
        txtFieldHospitalBloodBankAddressCity.delegate = self
        txtFieldHospitalBloodBankAddressPINCode.delegate = self
        self.textFieldPadding()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(RequestView.dismissKeyboard))
        let size = CGSize(width: 20, height: 20)

        scrollViewRequest.contentSize = size

        view.addGestureRecognizer(tap)
        self.navigationController?.completelyTransparentBar()

        // Do any additional setup after loading the view.
    }
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    //MARK:- Text Field Padding
    func textFieldPadding()
    {
        txtFieldPatientName.setLeftPaddingPoints(10.0)
        txtFieldContactPerson.setLeftPaddingPoints(10.0)
        txtFieldContactNumber.setLeftPaddingPoints(10.0)
        txtFieldHospitalBloodBankName.setLeftPaddingPoints(10.0)
        txtFieldDoctorName.setLeftPaddingPoints(10.0)
        txtFieldHospitalBloodBankContactNumber.setLeftPaddingPoints(10.0)
        txtFieldHospitalBloodBankAddress.setLeftPaddingPoints(10.0)
        txtFieldHospitalBloodBankAddressLandMark.setLeftPaddingPoints(10.0)
        txtFieldHospitalBloodBankAddressCity.setLeftPaddingPoints(10.0)
        txtFieldHospitalBloodBankAddressPINCode.setLeftPaddingPoints(10.0)
    }
    //MARK:- btnWhatYouNeedTapped
    @IBAction func btnWhatYouNeedTapped(_ sender: Any)
    {
        let viewBloodInfo: BloodInfoView = self.storyboard?.instantiateViewController(withIdentifier: "BloodInfoView") as! BloodInfoView
        viewBloodInfo.delegate = self
        viewBloodInfo.pickerArray = self.whatneedArray
        self.buttonupdate = "Need"
        viewBloodInfo.bloodInfoString = "Select what you need"
        viewBloodInfo.modalPresentationStyle = .overCurrentContext
        viewBloodInfo.view.backgroundColor =  UIColor.clear
        self.present(viewBloodInfo, animated: true, completion: nil)

    }
    //MARK:- btnWhenYouNeedTapped
    @IBAction func btnWhenYouNeedTapped(_ sender: Any)
    {
        let viewCalendar: CalendarView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView") as! CalendarView
        viewCalendar.delegate = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        viewCalendar.dateFormatter = dateFormatter
        let headingString = "Confirm Your Date"
        viewCalendar.calenderHeading = headingString
        viewCalendar.calendar.minimumDate = Date() as Date
        viewCalendar.calendar.datePickerMode = UIDatePickerMode.date
        viewCalendar.modalPresentationStyle = .overCurrentContext
        viewCalendar.view.backgroundColor =  UIColor.black.withAlphaComponent(0.5)

        self.present(viewCalendar, animated: true, completion: nil)
    }
    //MARK:- btnBloodGroupTapped
    @IBAction func btnBloodGroupTapped(_ sender: Any)
    {
        let viewBloodInfo: BloodInfoView = self.storyboard?.instantiateViewController(withIdentifier: "BloodInfoView") as! BloodInfoView
        viewBloodInfo.delegate = self
        self.buttonupdate = "BloodGroup"
        viewBloodInfo.pickerArray = self.bloodGroupArray
        viewBloodInfo.bloodInfoString = "Select your blood group"
        viewBloodInfo.modalPresentationStyle = .overCurrentContext
        viewBloodInfo.view.backgroundColor =  UIColor.black.withAlphaComponent(0.5)
        self.present(viewBloodInfo, animated: true, completion: nil)

    }
    //MARK:- btnBloodUnitTapped
    @IBAction func btnBloodUnitTapped(_ sender: Any)
    {
        let viewBloodInfo: BloodInfoView = self.storyboard?.instantiateViewController(withIdentifier: "BloodInfoView") as! BloodInfoView
        viewBloodInfo.delegate = self
        self.buttonupdate = "Units"
        viewBloodInfo.pickerArray = self.bloodUnitArray
        viewBloodInfo.bloodInfoString = "Select number of units"
        viewBloodInfo.modalPresentationStyle = .overCurrentContext
        viewBloodInfo.view.backgroundColor =  UIColor.black.withAlphaComponent(0.5)
        self.present(viewBloodInfo, animated: true, completion: nil)
    }
    //MARK:- GoogleMap IBAction
    @IBAction func btnGoogleMapTapped(_ sender: Any)
    {
    }
    //MARK:- SwitchShareAction
    @IBAction func switchShareTapped(_ sender: Any)
    {
        if switchForAppeal.isOn {
            print("Switch is off")
            txtViewPersonalAppeal.isEditable = false
            txtViewPersonalAppeal.text = ""
            switchForAppeal.setOn(false, animated:true)
        } else {
            print("The Switch is On")
            txtViewPersonalAppeal.isEditable = true
            switchForAppeal.setOn(true, animated:true)
        }
    }
    //MARK:- btnBackTapped
    @IBAction func btnBackTapped(_ sender: Any)
    {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
        
    }
    //MARK:- btnSubmmitTapped
    @IBAction func btnSubmitTapped(_ sender: Any)
    {
        view.endEditing(true)
        
        if txtFieldPatientName.text == "" || txtFieldContactNumber.text == "" || txtFieldContactNumber.text == "" || (btnWhatYouNeed.titleLabel?.text)! == "" || (btnBloodUnit.titleLabel?.text)! == "" || (btnWhenYouNeed.titleLabel?.text)! == "" || (btnBloodGroup.titleLabel?.text)! == "" || txtFieldHospitalBloodBankName.text == "" || txtFieldHospitalBloodBankContactNumber.text == "" || txtFieldHospitalBloodBankAddressPINCode.text == "" || txtFieldHospitalBloodBankAddress.text == "" || txtFieldHospitalBloodBankAddressCity.text == "" || txtFieldHospitalBloodBankAddressLandMark.text == ""
        {
            self.view.makeToast("Please fill all the fields", duration: 2.0, position: .bottom)
        }
        else{
            print("Print submit")
        }
        
    }
}
extension RequestView:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if self.txtFieldHospitalBloodBankName == textField
        {
            let hospitalListView = self.storyboard!.instantiateViewController(withIdentifier: "HospitalListView") as! HospitalListView
            hospitalListView.delegate = self
            let navController = UINavigationController(rootViewController: hospitalListView)
            self.navigationController?.present(navController, animated: true, completion: nil)
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {

        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if newString.characters.count > 0
        {
            switch textField
            {
            case txtFieldContactNumber:
                if newString.characters.count < 4 || newString.characters.count > 13
                {
                    self.txtFieldContactNumber.errorLine()
                }
                else{
                    self.txtFieldContactNumber.removeErrorLine()
                }
            case txtFieldHospitalBloodBankContactNumber :
                if newString.characters.count < 4 || newString.characters.count > 13
                {
                    self.txtFieldHospitalBloodBankContactNumber.errorLine()
                }
                else{
                    self.txtFieldHospitalBloodBankContactNumber.removeErrorLine()
                }
            case txtFieldHospitalBloodBankAddressPINCode:
                if newString.characters.count < 6 || newString.characters.count > 13
                {
                    txtFieldHospitalBloodBankAddressPINCode.errorLine()
                    
                }
                else{
                    txtFieldHospitalBloodBankAddressPINCode.removeErrorLine()
                }
            default:
                print("Done")
            }
        }
        return true;
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }

}

//MARK:- HospitalListCompletDataProtocol
extension RequestView:HospitalListCompletDataProtocol
{
    func SuccessHospitalListCompletData(ListData:HospitalListModel)
    {
        self.txtFieldHospitalBloodBankName.text = ListData.HospitalName
        self.txtFieldHospitalBloodBankAddress.text = ListData.AddressLine
        self.txtFieldHospitalBloodBankAddressCity.text = ListData.City
        if ListData.HospitalContactNumber != nil
        {
            self.txtFieldHospitalBloodBankContactNumber.text = String(describing: ListData.HospitalContactNumber!)
        }
        else
        {
            self.txtFieldHospitalBloodBankContactNumber.text = ""
        }
        
        self.txtFieldHospitalBloodBankAddressPINCode.text = ListData.PINCode
        self.txtFieldHospitalBloodBankAddressLandMark.text = ListData.Landmark
    }

}
extension RequestView:ProtocolBloodInfo
{
    func SuccessProtocolBloodInfo(valueSent: String)
    {
        self.checkdatafromprevious = valueSent
        if self.buttonupdate == "Need"
        {
            btnWhatYouNeed.titleLabel?.text = self.checkdatafromprevious
        }
        else if self.buttonupdate == "BloodGroup"
        {
            btnBloodGroup.titleLabel?.text = self.checkdatafromprevious
        }
        else
        {
            btnBloodUnit.titleLabel?.text = self.checkdatafromprevious
        }
    }
    
    func FailureProtocolBloodInfo(valueSent: String)
    {
        self.checkdatafromprevious = valueSent
    }
    
}
extension RequestView:ProtocolCalendar
{
    
    func SuccessProtocolCalendar(valueSent: String)
    {
        self.whenYouNeedString = valueSent
        btnWhenYouNeed.titleLabel?.text = self.whenYouNeedString
        print("whenYouNeedString",self.whenYouNeedString!)
    }
    
    func FailureProtocolCalendar(valueSent: String)
    {
        print("Try Again")
    }
}


