//
//  RequestView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import Social
import Toast_Swift

class RequestView: UIViewController,UITextViewDelegate
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
    @IBOutlet var scrollViewRequest: UIScrollView!
    
    //MARK:- String
    var datetostring = String()
    
    //MARK:- Arrays
    let bloodGroupArray = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    let bloodUnitArray = ["1","2","3","4","5","6","7","8","9","10"]
    let whatneedArray = ["Blood","Platelets","Plasma"]

    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.textFieldPadding()
    }
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(RequestView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RequestView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        //MARK - Reval View Button
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        self.navigationController?.completelyTransparentBar()
        self.txtViewPersonalAppeal.delegate = self
    }
    
    //MARK:- Keyboard Appear/Diappear
    func keyboardWillShow(notification:NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset:UIEdgeInsets = self.scrollViewRequest.contentInset
            contentInset.bottom = keyboardSize.size.height
            self.scrollViewRequest.contentInset = contentInset
        }
    }
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollViewRequest.contentInset = contentInset
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        viewCalendar.calenderHeading = "Confirm Your Date"
        viewCalendar.calendar.minimumDate = Date() as Date
        viewCalendar.calendar.datePickerMode = UIDatePickerMode.date
        viewCalendar.modalPresentationStyle = .overCurrentContext
        viewCalendar.view.backgroundColor =  UIColor.clear
        self.present(viewCalendar, animated: true, completion: nil)
    }
    //MARK:- btnBloodGroupTapped
    @IBAction func btnBloodGroupTapped(_ sender: Any)
    {
        let viewBloodInfo: BloodInfoView = self.storyboard?.instantiateViewController(withIdentifier: "BloodInfoView") as! BloodInfoView
        viewBloodInfo.delegate = self
        viewBloodInfo.pickerArray = self.bloodGroupArray
        viewBloodInfo.bloodInfoString = "Select your blood group"
        viewBloodInfo.modalPresentationStyle = .overCurrentContext
        viewBloodInfo.view.backgroundColor =  UIColor.clear
        self.present(viewBloodInfo, animated: true, completion: nil)
    }
    //MARK:- btnBloodUnitTapped
    @IBAction func btnBloodUnitTapped(_ sender: Any)
    {
        let viewBloodInfo: BloodInfoView = self.storyboard?.instantiateViewController(withIdentifier: "BloodInfoView") as! BloodInfoView
        viewBloodInfo.delegate = self
        viewBloodInfo.pickerArray = self.bloodUnitArray
        viewBloodInfo.bloodInfoString = "Select number of units"
        viewBloodInfo.modalPresentationStyle = .overCurrentContext
        viewBloodInfo.view.backgroundColor =  UIColor.clear
        self.present(viewBloodInfo, animated: true, completion: nil)
    }
    //MARK:- GoogleMap IBAction
    @IBAction func btnGoogleMapTapped(_ sender: Any)
    {
        let hospitalInMap = self.storyboard?.instantiateViewController(withIdentifier: "ShowHospitalInMapView") as! ShowHospitalInMapView!
        let AddressStr = ("\(txtFieldHospitalBloodBankAddress.text!) \(txtFieldHospitalBloodBankAddressCity.text!) \(txtFieldHospitalBloodBankAddressLandMark.text!) \(txtFieldHospitalBloodBankAddressPINCode.text!)")
        hospitalInMap?.delegate = self
        hospitalInMap?.addresstring = AddressStr
        self.navigationController?.present(hospitalInMap!, animated: true, completion: nil)
    }
    //MARK:- SwitchShareAction
    @IBAction func switchShareTapped(_ sender: Any)
    {
        if switchForAppeal.isOn {
            print("Switch is off")
            txtViewPersonalAppeal.isEditable = false
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
        if (txtFieldPatientName.text?.characters.count)! < 1 || (txtFieldContactNumber.text?.characters.count)! < 1 || (txtFieldContactPerson.text?.characters.count)! < 1 || (txtFieldHospitalBloodBankName.text?.characters.count)! < 1 || (txtFieldHospitalBloodBankContactNumber.text?.characters.count)! < 1 || (txtFieldHospitalBloodBankAddressPINCode.text?.characters.count)! < 1 || (txtFieldDoctorName.text?.characters.count)! < 1 || (txtFieldHospitalBloodBankAddress.text?.characters.count)! < 1 || (txtFieldHospitalBloodBankAddressLandMark.text?.characters.count)! < 1 || (txtFieldHospitalBloodBankAddressCity.text?.characters.count)! < 1
        {
            self.view.makeToast("Please fill all Mandatory fields", duration: 2.0, position: .bottom)
            
        }
        else{
            if RequestViewModel.SharedInstance.isContactNumber == false
            {
                self.view.makeToast("Invalid Contact Number", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.isHospitalContactNumber == false
            {
                self.view.makeToast("Invalid Hospial Contact Number", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.isPin == false
            {
                self.view.makeToast("Invalid Hospial Address PIN Code", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.BloodGroup == nil
            {
                self.view.makeToast("Please select Blood Group", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.WhatYouNeed == nil
            {
                self.view.makeToast("Please select What You Need", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.WhenYouNeed == nil
            {
                self.view.makeToast("Please select When You Need", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.BloodUnit == nil
            {
                self.view.makeToast("Please select Units", duration: 2.0, position: .bottom)
                return
            }
            if RequestViewModel.SharedInstance.Longitude == nil
            {
                RequestViewModel.SharedInstance.Longitude = "0"
            }
            if RequestViewModel.SharedInstance.Latitude == nil
            {
                RequestViewModel.SharedInstance.Latitude = "0"
            }
            
            let LoginID:String
                = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
            
            HudBar.sharedInstance.showHudWithMessage(message: "Submiting...", view: self.view)
            RequestInterator.SharedInstance.delegateRequestBlood = self
            let CentreID = RequestViewModel.SharedInstance.CentreID
           
            print(CentreID)
            
            RequestInterator.SharedInstance.requesBlood(LoginId: LoginID,bloodgroup: RequestViewModel.SharedInstance.BloodGroup!,whatyouneed: RequestViewModel.SharedInstance.WhatYouNeed!,whenyouneed: Util.SharedInstance.dateChangeForServerForProfile(dateString: RequestViewModel.SharedInstance.WhenYouNeed!),Units: RequestViewModel.SharedInstance.BloodUnit!,patientname: txtFieldPatientName.text!,contactperson: txtFieldContactPerson.text!,contactnumber: txtFieldContactNumber.text!,doctorname:txtFieldDoctorName.text!,doctorcontactnumber:"9999999999",doctoremailID: "",centerID:CentreID,centername: self.txtFieldHospitalBloodBankName.text!,centercontactnumber:txtFieldHospitalBloodBankContactNumber.text!,centeraddress: txtFieldHospitalBloodBankAddress.text!,City: txtFieldHospitalBloodBankAddressCity.text!,State: "",
                Landmark: txtFieldHospitalBloodBankAddressLandMark.text!,Latitude: RequestViewModel.SharedInstance.Latitude!,Longitude: RequestViewModel.SharedInstance.Longitude!,Pincode: txtFieldHospitalBloodBankAddressPINCode.text!,Country: "",personalappeal: txtViewPersonalAppeal.text!,Sharedinsocialmedia:"0")
        }
    }
}

extension RequestView:ProtocolRequestView
{
    
    func succesfullyBloodRequest(success:Bool)
    {
        if success == true
        {
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: "Your BloodRequest Submitted Successfully", view: self.view)
            if switchForAppeal.isOn
            {
                    if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook))
                        
                {
                    let SocialMedia :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                            
                            SocialMedia.completionHandler =
                                {
                                    result -> Void in
                                    
                                    let getResult = result as SLComposeViewControllerResult;
                                    switch(getResult.rawValue) {
                                    case SLComposeViewControllerResult.cancelled.rawValue: self.view.makeToast("Cancelled")
                                    case SLComposeViewControllerResult.done.rawValue: self.view.makeToast("Your post has been posted successfully")
                                    default: print("Error!")
                                    }
                                    self.dismiss(animated: true, completion: nil)
                            }
                        SocialMedia.setInitialText(txtViewPersonalAppeal.text)
                    }
                    else
                    {
                        let alert = UIAlertController(title: "Facebook App not installed.", message: "Your device has no Facebook installed.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            self.view.makeToast("Unable to access server, please try again later", duration: 2.0, position: .bottom)
        }
    }
    
    func failedBloodRequest()
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        self.view.makeToast("Unable to access server, please try again later", duration: 2.0, position: .bottom)
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.characters.count == 0 {
            switch textField {
            case txtFieldPatientName:
                txtFieldPatientName.errorLine()
            case txtFieldContactPerson:
                txtFieldContactPerson.errorLine()
            case txtFieldContactNumber:
                txtFieldContactNumber.errorLine()
          
            case txtFieldHospitalBloodBankContactNumber:
                txtFieldHospitalBloodBankContactNumber.errorLine()
            case txtFieldDoctorName:
                txtFieldDoctorName.errorLine()
            case txtFieldHospitalBloodBankAddress:
                txtFieldHospitalBloodBankAddress.errorLine()
            case txtFieldHospitalBloodBankAddressLandMark:
                txtFieldHospitalBloodBankAddressLandMark.errorLine()
            case txtFieldHospitalBloodBankAddressCity:
                txtFieldHospitalBloodBankAddressCity.errorLine()
            case txtFieldHospitalBloodBankAddressPINCode:
                txtFieldHospitalBloodBankAddressPINCode.errorLine()
            
            default:
                print("E-Default case")
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if newString.characters.count > 0
        {
            switch textField
            {
            case txtFieldPatientName:
                txtFieldPatientName.removeErrorLine()
            case txtFieldContactPerson:
                txtFieldContactPerson.removeErrorLine()

            case txtFieldDoctorName:
                txtFieldDoctorName.removeErrorLine()
            case txtFieldHospitalBloodBankAddress:
                txtFieldHospitalBloodBankAddress.removeErrorLine()
            case txtFieldHospitalBloodBankAddressLandMark:
                txtFieldHospitalBloodBankAddressLandMark.removeErrorLine()
            case txtFieldHospitalBloodBankAddressCity:
            txtFieldHospitalBloodBankAddressCity.removeErrorLine()
                
            case txtFieldContactNumber:
                if newString.characters.count < 4 || newString.characters.count > 13
                {
                    self.txtFieldContactNumber.errorLine()
                    RequestViewModel.SharedInstance.isContactNumber = false
                }
                else{
                    self.txtFieldContactNumber.removeErrorLine()
                    RequestViewModel.SharedInstance.isContactNumber = true
                }
            case txtFieldHospitalBloodBankContactNumber :
                if newString.characters.count < 4 || newString.characters.count > 13
                {
                    self.txtFieldHospitalBloodBankContactNumber.errorLine()
                    RequestViewModel.SharedInstance.isHospitalContactNumber = true
                }
                else{
                    self.txtFieldHospitalBloodBankContactNumber.removeErrorLine()
                    RequestViewModel.SharedInstance.isHospitalContactNumber = true
                }
            case txtFieldHospitalBloodBankAddressPINCode:
                if newString.characters.count < 4 || newString.characters.count > 10
                {
                    txtFieldHospitalBloodBankAddressPINCode.errorLine()
                    RequestViewModel.SharedInstance.isPin = false
                }
                else{
                    txtFieldHospitalBloodBankAddressPINCode.removeErrorLine()
                    RequestViewModel.SharedInstance.isPin = true
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
        RequestViewModel.SharedInstance.CentreID = ListData.CentreID
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
        
        if(ListData.Longitude == "")
        {
            RequestViewModel.SharedInstance.Longitude = "0"
        }else
        {
            RequestViewModel.SharedInstance.Longitude = ListData.Longitude
        }
        if(ListData.Latitude == "")
        {
            RequestViewModel.SharedInstance.Latitude = "0"
        }else
        {
            RequestViewModel.SharedInstance.Latitude = ListData.Latitude
        }
    }
}
extension RequestView:ProtocolBloodInfo
{
    func SuccessProtocolBloodInfo(valueSent: String, CheckString: String)
    {
        if (CheckString == "Select what you need")
        {
            btnWhatYouNeed.setTitle(valueSent, for: .normal)
            RequestViewModel.SharedInstance.WhatYouNeed = valueSent
        }
        else if (CheckString == "Select your blood group")
        {
            btnBloodGroup.setTitle(valueSent, for: .normal)
            RequestViewModel.SharedInstance.BloodGroup = valueSent
        }
        else if(CheckString == "Select number of units")
        {
            btnBloodUnit.setTitle(valueSent, for: .normal)
            RequestViewModel.SharedInstance.BloodUnit = valueSent
        }
    }
    func FailureProtocolBloodInfo(valueSent: String)
    {
    }
}
extension RequestView:ProtocolCalendar
{
    func SuccessProtocolCalendar(valueSent: String, CheckString: String)
    {
        btnWhenYouNeed.setTitle(valueSent, for: .normal)
        RequestViewModel.SharedInstance.WhenYouNeed = valueSent
    }
    func FailureProtocolCalendar(valueSent: String)
    {
        print("Try Again")
    }
}
extension RequestView:MyAddressFormat
{
    func SuccessMyAddressFormat(AddressResponse: AddressString,checkBool:Bool)
    {
        self.txtFieldHospitalBloodBankAddress.text = AddressResponse.addressString
        self.txtFieldHospitalBloodBankAddressCity.text = AddressResponse.City
        self.txtFieldHospitalBloodBankAddressPINCode.text = AddressResponse.PINCode
        
        RequestViewModel.SharedInstance.Latitude = AddressResponse.latitude
        RequestViewModel.SharedInstance.Longitude = AddressResponse.longitude
    }
}
