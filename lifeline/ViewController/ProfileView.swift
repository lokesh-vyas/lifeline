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
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.textFieldPadding()
    }
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileView.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.navigationController?.completelyTransparentBar()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        viewCalendar.calendar.datePickerMode = UIDatePickerMode.date
        viewCalendar.modalPresentationStyle = .overCurrentContext
        viewCalendar.view.backgroundColor =  UIColor.clear
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
        self.view.endEditing(true)
        if ProfileViewModel.SharedInstance.isEmail == false
        {
            self.view.makeToast("Invalid Email", duration: 2.0, position: .bottom)
            return
        }
        if ProfileViewModel.SharedInstance.isContactNumber == false
        {
            self.view.makeToast("Invalid Contact Number", duration: 2.0, position: .bottom)
            return
        }
        if (txtHomeAddressPINCode.text?.characters.count)! > 1
        {
            if ProfileViewModel.SharedInstance.isHomePin == false
            {
                self.view.makeToast("Invalid Home PIN code", duration: 2.0, position: .bottom)
                return
            }
        }
        if (txtWorkAddressPINCode.text?.characters.count)! > 1
        {
            if ProfileViewModel.SharedInstance.isWorkPin == false
            {
                self.view.makeToast("Invalid Home PIN code", duration: 2.0, position: .bottom)
                return
            }
        }
        if (txtName.text?.characters.count)! < 1 || (txtEmailID.text?.characters.count)! < 1 || (txtContactNumber.text?.characters.count)! < 1 || (txtAge.text?.characters.count)! < 1
        {
            self.view.makeToast("Please fill all Mandatory fields", duration: 2.0, position: .bottom)
            
        }else{
            //TODO:-
        }
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
                    ProfileViewModel.SharedInstance.isContactNumber = true
                }
                else{
                    txtContactNumber.removeErrorLine()
                    ProfileViewModel.SharedInstance.isContactNumber = false
                }
            case txtHomeAddressPINCode:
                if typedString.characters.count < 4 || typedString.characters.count > 13
                {
                    txtHomeAddressPINCode.removeErrorLine()
                    ProfileViewModel.SharedInstance.isHomePin = true
                }
                else{
                    txtHomeAddressPINCode.errorLine()
                    ProfileViewModel.SharedInstance.isHomePin = false
                }
            case txtWorkAddressPINCode:
                
                if typedString.characters.count < 4 || typedString.characters.count > 13
                {
                    txtWorkAddressPINCode.removeErrorLine()
                    ProfileViewModel.SharedInstance.isWorkPin = true
                } else {
                    txtWorkAddressPINCode.errorLine()
                    ProfileViewModel.SharedInstance.isWorkPin = false
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
    
    func SuccessProtocolCalendar(valueSent: String)
    {
        ProfileViewModel.SharedInstance.DOBstring = valueSent
        btnDOBOutlet.setTitle(ProfileViewModel.SharedInstance.DOBstring, for: .normal)
    }
    
    func FailureProtocolCalendar(valueSent: String)
    {
        print("Try Again")
    }
}
