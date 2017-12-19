//
//  CreateCommunityView.swift
//  lifeline
//
//  Created by Anjali on 30/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class CreateCommunityView: UIViewController {

    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var changeImage: UIImageView!
    let button = UIButton(frame: CGRect(x: 14, y: -7, width: 18, height: 18))
    override func viewDidLoad() {
        super.viewDidLoad()
        changeImage.setRounded()
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = button.bounds.size.height / 2
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black
        button.setBackgroundImage(UIImage(named: "Edit"), for: .normal)
        button.addTarget(self, action: #selector(BtnChangeProfilePicTapped), for: .touchUpInside)
        changeImage.addSubview(button)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    //MARK:- PushNotificationView
    func PushNotificationView(_ notification: NSNotification) {
        let dict = notification.object as! Dictionary<String, Any>
        let notificationView:NotificationView = self.storyboard?.instantiateViewController(withIdentifier: "NotificationView") as! NotificationView
        notificationView.UserJSON = dict
        notificationView.modalPresentationStyle = .currentContext
        notificationView.modalTransitionStyle = .coverVertical
        notificationView.view.backgroundColor = UIColor.clear
        self.present(notificationView, animated: true, completion: nil)
    }
    func BtnChangeProfilePicTapped() {
        print("Success")
    }
    @IBAction func btnBackTapped(_ sender: Any) {
    }
    @IBAction func btnClosedGroupTapped(_ sender: Any) {
    }
    @IBAction func btnOpenGroupTapped(_ sender: Any) {
    }
    @IBAction func btnCreateTapped(_ sender: Any) {
    }
}
