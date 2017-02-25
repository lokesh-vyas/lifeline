//
//  PopUp.swift
//  lifeline
//
//  Created by Apple on 23/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class PopUp: UIViewController {

    var markerInfo = [String]()
    
    @IBOutlet weak var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        lbl.text = markerInfo[0]
    }

    @IBAction func btnPopUp(_ sender: Any) {
        print("PopUp button tapped")
    }
    
}
