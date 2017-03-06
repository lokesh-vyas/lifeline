//
//  HomeView.swift
//  lifeline
//
//  Created by iSteer on 24/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import Firebase

class HomeView: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var revalMenuButton: UIBarButtonItem!
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    //MARK:- viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
       //MARK - Reval View Button
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if let refreshedToken = FIRInstanceID.instanceID().token()
        {
            print("InstanceID token: \(refreshedToken)")
        }
        
        if self.revealViewController() != nil {
            revalMenuButton.target = self.revealViewController()
            revalMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
//MARK:- DonateAction
    @IBAction func DonateAction(_ sender: Any)
    {
        let donateView = self.storyboard?.instantiateViewController(withIdentifier: "DonateView")
        self.navigationController?.pushViewController(donateView!, animated: true)

    }
//MARK:- RequestAction
    @IBAction func RequestAction(_ sender: Any)
    {
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "RequestView")
        self.navigationController?.pushViewController(requestView!, animated: true)
        
    }
//MARK:- MyRequestAction
    @IBAction func MyRequestAction(_ sender: Any)
    {
        let requestView = self.storyboard?.instantiateViewController(withIdentifier: "MyRequestView")
        self.navigationController?.pushViewController(requestView!, animated: true)
    }
}
