//
//  NotificationView.swift
//  lifeline
//
//  Created by iSteer on 09/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationView: UIViewController {

    @IBOutlet weak var lblTitleText: UILabel!
    @IBOutlet weak var lblMessageText: UILabel!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var UserJSON:Dictionary<String, Any> = Dictionary<String, Any>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(UserJSON)
        if (UserJSON["Type"] as? String == "1")
        {
            btnCancel.setTitle("Thanks", for: .normal)
            btnView.isHidden = true
        }
        self.lblTitleText.text = UserJSON["Title"] as? String
        self.lblMessageText.text = UserJSON["Message"] as? String
    }
    @IBAction func btnCancelTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnViewTapped(_ sender: Any)
    {
        if (UserJSON["Type"] as? String == "2")
        {
            print(UserJSON["ID"]!)
            let myDonorView:MyDonorView = self.storyboard?.instantiateViewController(withIdentifier: "MyDonorView") as! MyDonorView
            myDonorView.MyRequestIDFromPush = UserJSON["ID"] as! String
            let rootView:UINavigationController = UINavigationController.init(rootViewController: myDonorView)
            self.present(rootView, animated: true, completion: nil)
        }
    }
}
