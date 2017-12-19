//
//  MyCommunityView.swift
//  lifeline
//
//  Created by Anjali on 29/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyCommunityView: UIViewController {
    @IBOutlet weak var lblNoCommunity: UILabel!
    @IBOutlet weak var tblCommunity: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.completelyTransparentBar()
        tblCommunity.contentInset = UIEdgeInsetsMake(-30, 0.0, -20, 0.0)
        lblNoCommunity.isHidden = true
        tblCommunity.isHidden = true
        HudBar.sharedInstance.showHudWithMessage(message: MultiLanguage.getLanguageUsingKey("TOAST_LOADING_MESSAGE"), view: self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(PushNotificationView(_:)), name: NSNotification.Name(rawValue: "PushNotification"), object: nil)
    }
    @IBAction func btnBackTapped(_ sender: Any) {
        let SWRevealView = self.storyboard!.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.navigationController?.present(SWRevealView, animated: true, completion: nil)
    }
    @IBAction func btnExploreTapped(_ sender: Any) {
    }
    @IBAction func btnCreateCommunityTapped(_ sender: Any) {
    }
    @IBAction func btnInvitesTapped(_ sender: Any) {
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
}
/*extension MyCommunityView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}*/
