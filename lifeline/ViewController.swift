//
//  ViewController.swift
//  lifeline
//
//  Created by iSteer on 06/01/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var txtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func btnOKTapped(_ sender: Any) {
        
        lblWelcome.text = txtField.text
    }


}

