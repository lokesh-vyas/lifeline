//
//  ProfileView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileView: UIViewController
{
    //MARK:- IBOutlet
    @IBOutlet weak var txtName: FloatLabelTextField!
    @IBOutlet weak var txtEmailID: FloatLabelTextField!
    @IBOutlet weak var txtContactNumber: FloatLabelTextField!
    @IBOutlet weak var txtHomeAddressLine: FloatLabelTextField!
    @IBOutlet weak var txtHomeAddressCity: FloatLabelTextField!
    @IBOutlet weak var txtHomeAddressPINCode: FloatLabelTextField!
    @IBOutlet weak var txtAge: FloatLabelTextField!
    @IBOutlet weak var txtWorkAddressLine: FloatLabelTextField!
    @IBOutlet weak var txtWorkAddressCity: FloatLabelTextField!
    @IBOutlet weak var txtWorkAddressPINCode: FloatLabelTextField!
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet var btnDOBOutlet: UIButton!
    @IBOutlet weak var btnBloodGroup: UIButton!
    @IBOutlet weak var btnLastDonationDate: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    var tempBool : Bool = false
    var tempStr : String?
    let bloodGroupArray = ["O+","O-","A+","A-","B+","B-","AB+","AB-"]
    var name : String?
    var emailID : String?
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.textFieldPadding()
        let profileSuccess = UserDefaults.standard.bool(forKey: "SuccessProfileRegistration")
        if profileSuccess == false
        {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        btnSubmit.setTitle(MultiLanguage.getLanguageUsingKey("BTN_SUBMIT"), for: .normal)
        let data = UserDefaults.standard.object(forKey: "ProfileData")
        if data != nil {
            let profileData:ProfileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
            self.showDataOnView(profileData: profileData)
        }
        else
        {
            let LoginId:String = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
            HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_PLEASE_WAIT"), view: self.view)
            ProfileViewInteractor.SharedInstance.delegate = self
            ProfileViewInteractor.SharedInstance.checkGetProfileData(LoginID: LoginId)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileView.PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
        self.navigationController?.completelyTransparentBar()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:- Share Application URL With Activity
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
    
    //MARK:- Show Data On view
    func showDataOnView(profileData:ProfileData)
    {
        self.txtName.text! = profileData.Name
        self.txtEmailID.text! = profileData.EmailId
        self.txtContactNumber.text! = profileData.ContactNumber
        self.txtAge.text! = profileData.Age
        
        if profileData.DateofBirth != ""
        {
            ProfileViewModel.SharedInstance.DOBstring = profileData.DateofBirth
            btnDOBOutlet.setTitle(profileData.DateofBirth, for: .normal)
        }
        
        if profileData.BloodGroup != ""
        {
            ProfileViewModel.SharedInstance.BloodGroup = profileData.BloodGroup
            btnBloodGroup.setTitle(profileData.BloodGroup, for: .normal)
        }
        if profileData.LastDonatedOn != ""
        {
            ProfileViewModel.SharedInstance.LastDonationStrin = profileData.LastDonatedOn
            btnLastDonationDate.setTitle(profileData.LastDonatedOn, for: .normal)
        }
        if profileData.HomeAddressCity != ""
        {
            self.txtHomeAddressCity.text! = profileData.HomeAddressCity
        }
        if profileData.HomeAddressPINCode != ""
        {
            self.txtHomeAddressPINCode.text! = profileData.HomeAddressPINCode
        }
        if profileData.HomeAddressLine != ""
        {
            self.txtHomeAddressLine.text! = profileData.HomeAddressLine
        }
        if profileData.WorkAddressLine != ""
        {
            self.txtWorkAddressLine.text! = profileData.WorkAddressLine
        }
        if profileData.WorkAddressCity != ""
        {
            self.txtWorkAddressCity.text! = profileData.WorkAddressCity
        }
        if profileData.WorkAddressPINCode != ""
        {
            self.txtWorkAddressPINCode.text! = profileData.WorkAddressPINCode
        }
    }
    //MARK:- Text Field Padding
    func textFieldPadding()
    {
        txtName.setLeftPaddingPoints(10.0)
        txtEmailID.setLeftPaddingPoints(10.0)
        txtAge.setLeftPaddingPoints(10.0)
        txtContactNumber.setLeftPaddingPoints(10.0)
        txtHomeAddressLine.setLeftPaddingPoints(10.0)
        txtHomeAddressCity.setLeftPaddingPoints(10.0)
        txtHomeAddressPINCode.setLeftPaddingPoints(10.0)
        txtWorkAddressLine.setLeftPaddingPoints(10.0)
        txtWorkAddressCity.setLeftPaddingPoints(10.0)
        txtWorkAddressPINCode.setLeftPaddingPoints(10.0)
    }
    //MARK:- keyboard Appear / DisAppear
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var contentInset:UIEdgeInsets = self.profileScrollView.contentInset
            contentInset.bottom = keyboardSize.size.height
            self.profileScrollView.contentInset = contentInset
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            self.profileScrollView.contentInset = contentInset
        }
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
        self.view.endEditing(true)
        let viewBloodInfo: BloodInfoView = self.storyboard?.instantiateViewController(withIdentifier: "BloodInfoView") as! BloodInfoView
        viewBloodInfo.delegate = self
        viewBloodInfo.pickerArray = self.bloodGroupArray
        viewBloodInfo.bloodInfoString = MultiLanguage.getLanguageUsingKey("SELECT_BLOOD_GROUP")
        viewBloodInfo.modalPresentationStyle = .overCurrentContext
        viewBloodInfo.view.backgroundColor =  UIColor.clear
        viewBloodInfo.modalTransitionStyle = .coverVertical
        self.present(viewBloodInfo, animated: true, completion: nil)
    }
    //MARK:- DateOfBirthAction
    @IBAction func DOBAction(_ sender: Any) {
        
        self.view.endEditing(true)
        let viewCalendar: CalendarView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView") as! CalendarView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        viewCalendar.delegate = self
        viewCalendar.dateFormatter = dateFormatter
        viewCalendar.calenderHeading = MultiLanguage.getLanguageUsingKey("DATE_OF_BIRTH")
        viewCalendar.calendar.maximumDate = Date() as Date
        viewCalendar.calendar.datePickerMode = UIDatePickerMode.date
        viewCalendar.modalPresentationStyle = .overCurrentContext
        viewCalendar.modalTransitionStyle = .coverVertical
        viewCalendar.view.backgroundColor =  UIColor.clear
        self.present(viewCalendar, animated: true, completion: nil)
    }
    //MARK:- LastDonationDate
    @IBAction func lastDonationDate(_ sender: Any)
    {
        self.view.endEditing(true)
        let viewCalendar: CalendarView = self.storyboard?.instantiateViewController(withIdentifier: "CalendarView") as! CalendarView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        viewCalendar.delegate = self
        viewCalendar.dateFormatter = dateFormatter
        viewCalendar.calenderHeading = MultiLanguage.getLanguageUsingKey("LAST_DONATION_DATE")
        viewCalendar.calendar.maximumDate = Date() as Date
        viewCalendar.calendar.datePickerMode = UIDatePickerMode.date
        viewCalendar.modalPresentationStyle = .overCurrentContext
        viewCalendar.modalTransitionStyle = .coverVertical
        viewCalendar.view.backgroundColor =  UIColor.clear
        self.present(viewCalendar, animated: true, completion: nil)
    }
    //MARK:- HomeGoogleMapAction
    @IBAction func homeGoogleMapAction(_ sender: Any)
    {
        let hospitalInMap = self.storyboard?.instantiateViewController(withIdentifier: "ShowHospitalInMapView") as! ShowHospitalInMapView!
        let AddressStr = ("\(self.txtHomeAddressLine.text!) \(self.txtHomeAddressCity.text!) \(txtHomeAddressPINCode.text!)")
        hospitalInMap?.delegate = self
        hospitalInMap?.addresstring = AddressStr
        hospitalInMap?.checkBool = true
        let navBar = UINavigationController(rootViewController: hospitalInMap!)
        self.present(navBar, animated: true, completion: nil)
    }
    //MARK:- WorkGoogleMapAction
    @IBAction func workGoogleMapAction(_ sender: Any)
    {
        let hospitalInMap = self.storyboard?.instantiateViewController(withIdentifier: "ShowHospitalInMapView") as! ShowHospitalInMapView!
        let AddressStr = ("\(self.txtWorkAddressLine.text!) \(self.txtWorkAddressCity.text!) \(self.txtWorkAddressPINCode.text!)")
        hospitalInMap?.checkBool = false
        hospitalInMap?.delegate = self
        hospitalInMap?.addresstring = AddressStr
        let navBar = UINavigationController(rootViewController: hospitalInMap!)
        self.present(navBar, animated: true, completion: nil)
    }
    //MARK:- ProfileSubmitAction
    @IBAction func profileSubmitAction(_ sender: Any)
    {
        self.view.endEditing(true)
        
        if ProfileViewModel.SharedInstance.isEmail == false
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_INVALID_MAIL_ID"), duration: 2.0, position: .bottom)
            return
        }
        if ProfileViewModel.SharedInstance.isContactNumber == false
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_INVALID_CONTACT"), duration: 2.0, position: .bottom)
            return
        }
        
        if ProfileViewModel.SharedInstance.BloodGroup == nil
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("SELECT_BLOOD_GROUP"), duration: 2.0, position: .bottom)
            return
        }
        if (txtHomeAddressPINCode.text?.characters.count)! > 1
        {
            if ProfileViewModel.SharedInstance.isHomePin == false
            {
                self.view.makeToast(MultiLanguage.getLanguageUsingKey("INVALID_HOME_PIN"), duration: 2.0, position: .bottom)
                return
            }
        }
        if (txtWorkAddressPINCode.text?.characters.count)! > 1
        {
            if ProfileViewModel.SharedInstance.isWorkPin == false
            {
                self.view.makeToast(MultiLanguage.getLanguageUsingKey("INVALID_HOME_PIN"), duration: 2.0, position: .bottom)
                return
            }
        }
        
        if (txtName.text?.characters.count)! < 1 || (txtEmailID.text?.characters.count)! < 1 || (txtContactNumber.text?.characters.count)! < 1 || (txtAge.text?.characters.count)! < 1
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("ERROR_ALL_MANDATORY_NEW_FIELDS"), duration: 2.0, position: .bottom)
            
        }else{
            //TODO:-
            
            if self.txtHomeAddressCity.text?.characters.count == 0
            {
                self.txtHomeAddressCity.text! = ""
            }
            if self.txtHomeAddressLine.text?.characters.count == 0
            {
                self.txtHomeAddressLine.text! = ""
            }
            if self.txtHomeAddressPINCode.text?.characters.count == 0
            {
                self.txtHomeAddressPINCode.text! = ""
            }
            if self.txtWorkAddressCity.text?.characters.count == 0
            {
                self.txtWorkAddressCity.text! = ""
            }
            if self.txtWorkAddressLine.text?.characters.count == 0
            {
                self.txtWorkAddressLine.text! = ""
            }
            if self.txtWorkAddressPINCode.text?.characters.count == 0
            {
                self.txtWorkAddressPINCode.text! = ""
            }
            if ProfileViewModel.SharedInstance.LastDonationStrin == nil
            {
                ProfileViewModel.SharedInstance.LastDonationStrin = ""
            }
            if ProfileViewModel.SharedInstance.DOBstring == nil
            {
                ProfileViewModel.SharedInstance.DOBstring = ""
            }
            if ProfileViewModel.SharedInstance.workLat == ""
            {
                ProfileViewModel.SharedInstance.workLat = "0"
            }
            if ProfileViewModel.SharedInstance.workLong == ""
            {
                ProfileViewModel.SharedInstance.workLong = "0"
            }
            if ProfileViewModel.SharedInstance.homeLat == ""
            {
                ProfileViewModel.SharedInstance.homeLat = "0"
            }
            if ProfileViewModel.SharedInstance.homeLong == ""
            {
                ProfileViewModel.SharedInstance.homeLong = "0"
            }
            if tempBool {
                ProfileViewModel.SharedInstance.DOBstring = ""
                tempStr = ""
            } else {
                 tempStr = ProfileViewModel.SharedInstance.DOBstring!
            }
            let profileData = ProfileData(Name: self.txtName.text!, EmailID: self.txtEmailID.text!, ContactNumber: self.txtContactNumber.text!, DateOfBirth: tempStr!, Age: self.txtAge.text!, BloodGroup: ProfileViewModel.SharedInstance.BloodGroup!, LastDonationDate: ProfileViewModel.SharedInstance.LastDonationStrin!, HomeAddressLine: self.txtHomeAddressLine.text!, HomeAddressCity: self.txtHomeAddressCity.text!, HomeAddressPINCode: self.txtHomeAddressPINCode.text!, HomeAddressLatitude: ProfileViewModel.SharedInstance.homeLat, HomeAddressLongitude: ProfileViewModel.SharedInstance.homeLong, WorkAddressLine: self.txtWorkAddressLine.text!, WorkAddressCity: self.txtWorkAddressCity.text!, WorkAddressPINCode: self.txtWorkAddressPINCode.text!, WorkAddressLatitude: ProfileViewModel.SharedInstance.workLat, WorkAddressLongitude: ProfileViewModel.SharedInstance.workLong)
            
            let data = NSKeyedArchiver.archivedData(withRootObject: profileData)
            UserDefaults.standard.set(data, forKey: "ProfileData")
            
            if ((self.txtHomeAddressCity.text?.characters.count != 0)||(self.txtHomeAddressPINCode.text?.characters.count != 0)||(self.txtHomeAddressLine.text?.characters.count != 0))
            {
                if ((self.txtWorkAddressLine.text?.characters.count != 0)||(self.txtWorkAddressPINCode.text?.characters.count != 0)||(self.txtWorkAddressCity.text?.characters.count != 0))
                {
                    //MARK:   With Home/Work Adress
                    self.serverBodyForProfileData(index: 4)
                }else
                {
                    //MARK: With Home Adress
                    self.serverBodyForProfileData(index: 3)
                }
            }else if ((self.txtWorkAddressLine.text?.characters.count != 0)||(self.txtWorkAddressPINCode.text?.characters.count != 0)||(self.txtWorkAddressCity.text?.characters.count != 0))
            {
                //MARK:   With Work Address
                self.serverBodyForProfileData(index: 2)
            }else{
                self.serverBodyForProfileData(index: 1)
            }
        }
    }
    func serverBodyForProfileData(index:Int)
    {
        var myNewDictArray = [Dictionary<String, String>]()
        switch index {
        case 1:
            //MARK: Without Home/Work Adress
            self.serverCallForProfileRegistration(myAddressDetail: myNewDictArray)
        case 2:
            myNewDictArray.append(["AddressType":"Work","AddressLine":self.txtWorkAddressLine.text!,"City": self.txtWorkAddressCity.text!,
                                   "LandMark": "",
                                   "State": "",
                                   "Country": "",
                                   "ZipCode": self.txtWorkAddressPINCode.text!,
                                   "Latitude": ProfileViewModel.SharedInstance.workLat,
                                   "Longitude": ProfileViewModel.SharedInstance.workLong])
            self.serverCallForProfileRegistration(myAddressDetail: myNewDictArray)
        //MARK:   With Work Address
        case 3:
            myNewDictArray.append(["AddressType":"Home","AddressLine":self.txtHomeAddressLine.text!,"City": self.txtHomeAddressCity.text!,
                                   "LandMark": "",
                                   "State": "",
                                   "Country": "",
                                   "ZipCode": self.txtHomeAddressPINCode.text!,
                                   "Latitude": ProfileViewModel.SharedInstance.homeLat,
                                   "Longitude": ProfileViewModel.SharedInstance.homeLong])
            self.serverCallForProfileRegistration(myAddressDetail: myNewDictArray)
        //MARK: With Home Adress
        case 4:
            //MARK:   With Home/Work Adress
            myNewDictArray.append(["AddressType":"Home","AddressLine":self.txtHomeAddressLine.text!,"City": self.txtHomeAddressCity.text!,
                                   "LandMark": "",
                                   "State": "",
                                   "Country": "",
                                   "ZipCode": self.txtHomeAddressPINCode.text!,
                                   "Latitude": ProfileViewModel.SharedInstance.homeLat,
                                   "Longitude": ProfileViewModel.SharedInstance.homeLong])
            myNewDictArray.append(["AddressType":"Work","AddressLine":self.txtWorkAddressLine.text!,"City": self.txtWorkAddressCity.text!,
                                   "LandMark": "",
                                   "State": "",
                                   "Country": "",
                                   "ZipCode": self.txtWorkAddressPINCode.text!,
                                   "Latitude": ProfileViewModel.SharedInstance.workLat,
                                   "Longitude": ProfileViewModel.SharedInstance.workLong])
            self.serverCallForProfileRegistration(myAddressDetail: myNewDictArray)
        default:
            self.serverCallForProfileRegistration(myAddressDetail: myNewDictArray)
        }
    }
    func serverCallForProfileRegistration(myAddressDetail:Any)
    {
        let LoginID:String
            = UserDefaults.standard.string(forKey: "LifeLine_User_Unique_ID")!
        let DateofBirth:String
        let LastDontaionDate:String
        
        if ProfileViewModel.SharedInstance.LastDonationStrin == ""
        {
            LastDontaionDate = ""
        }
        else
        {
            LastDontaionDate =  Util.SharedInstance.dateChangeForServerForProfile(dateString: ProfileViewModel.SharedInstance.LastDonationStrin!)
        }
        if ProfileViewModel.SharedInstance.DOBstring == ""
        {
            DateofBirth = ""
        }else
        {
            DateofBirth =  Util.SharedInstance.dateChangeForServerForProfile(dateString: ProfileViewModel.SharedInstance.DOBstring!)
        }
        let AuthProvider:String
            = UserDefaults.standard.string(forKey: "LoginInformation")!
        
        let customer : Dictionary = ["ProfileRegistrationRequest":["ProfileDetails":["LoginId":LoginID,"Name":self.txtName.text!,"DateofBirth":DateofBirth,"Age":self.txtAge.text!,"ContactNumber": self.txtContactNumber.text!, "BloodGroup": ProfileViewModel.SharedInstance.BloodGroup!,"EmailId": self.txtEmailID.text!,"AuthProvider": AuthProvider,"LastDonationDate": LastDontaionDate,"AddressDetails": myAddressDetail]]]
        
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_PLEASE_WAIT"), view: self.view)
        ProfileViewInteractor.SharedInstance.delegateProfile = self
        ProfileViewInteractor.SharedInstance.MyProfileRegistration(params: customer)
    }
}
//MARK:- TextViewDelegate
extension ProfileView:UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text?.characters.count == 0 {
            switch textField {
            case txtName:
                txtName.errorLine()
            case txtAge:
                txtAge.errorLine()
            case txtEmailID:
                txtEmailID.errorLine()
            case txtContactNumber:
                txtContactNumber.errorLine()
            default:
                print("E-Default case")
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true;
    }
    
    func OnTextChange()
    {
        //ProfileViewModel.SharedInstance.DOBstring = ""
        self.btnDOBOutlet.setTitle(MultiLanguage.getLanguageUsingKey("DATE_STRING"), for: .normal)
        tempBool = true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(OnTextChange), for: .editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let str = textField.text! as NSString
        let typedString = str.replacingCharacters(in: range, with: string)
        
        if typedString.characters.count > 0 {
            
            switch textField {
            case txtName:
                txtName.removeErrorLine()
            case txtAge:
                if typedString.characters.count < 3 {
                    txtAge.removeErrorLine()
                    
                } else {
                    txtAge.errorLine()
                }
            case txtEmailID:
                if typedString.isValidEmail(){
                    txtEmailID.removeErrorLine()
                    ProfileViewModel.SharedInstance.isEmail = true
                    
                } else {
                    txtEmailID.errorLine()
                    ProfileViewModel.SharedInstance.isEmail = false
                }
            case txtContactNumber:
                if typedString.characters.count < 4 || typedString.characters.count > 13
                {
                    txtContactNumber.errorLine()
                    ProfileViewModel.SharedInstance.isContactNumber = false
                }
                else{
                    txtContactNumber.removeErrorLine()
                    ProfileViewModel.SharedInstance.isContactNumber = true
                }
            case txtHomeAddressPINCode:
                
                if typedString.characters.count < 4 || typedString.characters.count > 13
                {
                    txtHomeAddressPINCode.errorLine()
                    ProfileViewModel.SharedInstance.isHomePin = false
                }
                else{
                    txtHomeAddressPINCode.removeErrorLine()
                    ProfileViewModel.SharedInstance.isHomePin = true
                }
                if typedString.characters.count <= 1
                {
                    txtHomeAddressPINCode.removeErrorLine()
                    ProfileViewModel.SharedInstance.isHomePin = true
                }
            case txtWorkAddressPINCode:
                
                if typedString.characters.count < 4 || typedString.characters.count > 13
                {
                    txtWorkAddressPINCode.errorLine()
                    ProfileViewModel.SharedInstance.isWorkPin = false
                } else {
                    txtWorkAddressPINCode.removeErrorLine()
                    ProfileViewModel.SharedInstance.isWorkPin = true
                }
                if typedString.characters.count <= 1
                {
                    txtWorkAddressPINCode.removeErrorLine()
                    ProfileViewModel.SharedInstance.isWorkPin = true
                }
                
            default:
                print("TODO")
            }
        }
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
}
//MARK:- ProtocolCalender
extension ProfileView:ProtocolCalendar
{
    
    func SuccessProtocolCalendar(valueSent: String,CheckString:String)
    {
        if CheckString == MultiLanguage.getLanguageUsingKey("DATE_OF_BIRTH")
        {
            //if tempBool {
                //btnDOBOutlet.setTitle("", for: .normal)
                //ProfileViewModel.SharedInstance.DOBstring = ""
            //} else {
                ProfileViewModel.SharedInstance.DOBstring = valueSent
                self.txtAge.text = Util.SharedInstance.calcAge(birthday: ProfileViewModel.SharedInstance.DOBstring!)
                btnDOBOutlet.setTitle(valueSent, for: .normal)
                txtAge.removeErrorLine()
            //}
        }
        else if CheckString == MultiLanguage.getLanguageUsingKey("LAST_DONATION_DATE")
        {
            ProfileViewModel.SharedInstance.LastDonationStrin = valueSent
            btnLastDonationDate.setTitle(valueSent, for: .normal)
        }
    }
    
    func FailureProtocolCalendar(valueSent: String)
    {
        if valueSent == "Clear"
        {
            ProfileViewModel.SharedInstance.LastDonationStrin = ""
            btnLastDonationDate.setTitle(MultiLanguage.getLanguageUsingKey("LAST_DONATION_DATE"), for: .normal)
        }
    }
}
//MARK:- ProtocolBloodInfo
extension ProfileView:ProtocolBloodInfo
{
    func SuccessProtocolBloodInfo(valueSent: String,CheckString:String)
    {
        ProfileViewModel.SharedInstance.BloodGroup = valueSent
        btnBloodGroup.setTitle(valueSent, for: .normal)
    }
    func FailureProtocolBloodInfo(valueSent: String)
    {
    }
}
//MARK:- ProtocolBloodInfo
extension ProfileView:ProtocolGetProfile
{
    func succesfullyGetProfile(success: Bool)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if success == true
        {
            let data = UserDefaults.standard.object(forKey: "ProfileData")
            if data != nil {
                let profileData:ProfileData = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! ProfileData
                self.showDataOnView(profileData: profileData)
            }
        }
        else
        {
            self.txtName.text = UserDefaults.standard.string(forKey: StringList.LifeLine_User_Name.rawValue)
            self.txtEmailID.text = UserDefaults.standard.string(forKey: StringList.LifeLine_User_Email.rawValue)
        }
    }
    func failedGetProfile(success: Bool)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if success == false
        {
            self.txtName.text = UserDefaults.standard.string(forKey: StringList.LifeLine_User_Name.rawValue)
            self.txtEmailID.text = UserDefaults.standard.string(forKey: StringList.LifeLine_User_Email.rawValue)
        }else if (success == true)
        {
            UserDefaults.standard.removeObject(forKey: StringList.LifeLine_User_Name.rawValue)
            UserDefaults.standard.removeObject(forKey: StringList.LifeLine_User_Email.rawValue)
            UserDefaults.standard.removeObject(forKey: StringList.LifeLine_User_ID.rawValue)
            UserDefaults.standard.set(true, forKey: "BloodBankUser")
            let loginView:LoginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
            let navBar = UINavigationController(rootViewController: loginView)
            self.present(navBar, animated: true, completion: nil)
        }
    }
}
//MARK:- ProtocolBloodInfo
extension ProfileView:ProtocolRegisterProfile
{
    func succesfullyRegisterProfile(success: Bool)
    {
        if success == true
        {
            UserDefaults.standard.set(true, forKey: "SuccessProfileRegistration")
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("SUCESS_PROFILE_UPDATE"), view: self.view)
            let deadlineTime = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute:
                {
                    let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.navigationController?.present(SWRevealView, animated: true, completion: nil)
            })
        }else{
            
            HudBar.sharedInstance.hideHudFormView(view: self.view)
            HudBar.sharedInstance.showHudWithLifeLineIconAndMessage(message: MultiLanguage.getLanguageUsingKey("ERROR_PROFILE_UPDATE"), view: self.view)
        }
    }
    func failedRegisterProfile(Response:String)
    {
        HudBar.sharedInstance.hideHudFormView(view: self.view)
        if Response == "NoInternet" {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_NO_INTERNET_WARNING"), duration: 3.0, position: .bottom)
        }else
        {
            self.view.makeToast(MultiLanguage.getLanguageUsingKey("TOAST_ACCESS_SERVER_WARNING"), duration: 3.0, position: .bottom)
        }
    }
}
extension ProfileView:MyAddressFormat
{
    func SuccessMyAddressFormat(AddressResponse: AddressString,checkBool:Bool)
    {
        if checkBool == true 
        {
            self.txtHomeAddressLine.text! = AddressResponse.addressString
            self.txtHomeAddressCity.text! = AddressResponse.City
            self.txtHomeAddressPINCode.text! = AddressResponse.PINCode
            
            ProfileViewModel.SharedInstance.homeLat = AddressResponse.latitude
            ProfileViewModel.SharedInstance.homeLong = AddressResponse.longitude
        }
        else
        {
            self.txtWorkAddressLine.text! = AddressResponse.addressString
            self.txtWorkAddressCity.text! = AddressResponse.City
            self.txtWorkAddressPINCode.text! = AddressResponse.PINCode
            
            ProfileViewModel.SharedInstance.workLat = AddressResponse.latitude
            ProfileViewModel.SharedInstance.workLong = AddressResponse.longitude
        }
    }
}
