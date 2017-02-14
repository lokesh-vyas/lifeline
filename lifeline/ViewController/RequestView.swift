//
//  RequestView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var btnBloodUnit: UIButton!
    @IBOutlet weak var btnBloodGroup: UIButton!
    @IBOutlet weak var btnWhenYouNeed: UIButton!
    @IBOutlet weak var btnWhatYouNeed: UIButton!
    
    @IBOutlet weak var imgSocialShare: UIImageView!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //MARK:- btnWhatYouNeedTapped
    @IBAction func btnWhatYouNeedTapped(_ sender: Any)
    {
    }
    //MARK:- btnWhenYouNeedTapped
    @IBAction func btnWhenYouNeedTapped(_ sender: Any)
    {
    }
    //MARK:- btnBloodGroupTapped
    @IBAction func btnBloodGroupTapped(_ sender: Any)
    {
    }
    //MARK:- btnBloodUnitTapped
    @IBAction func btnBloodUnitTapped(_ sender: Any)
    {
    }
    //MARK:- GoogleMap IBAction
    @IBAction func btnGoogleMapTapped(_ sender: Any)
    {
    }
    //MARK:- SwitchShareAction
    @IBAction func switchShareTapped(_ sender: Any)
    {
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
    }
}
