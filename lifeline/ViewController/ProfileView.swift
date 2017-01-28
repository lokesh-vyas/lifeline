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
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
