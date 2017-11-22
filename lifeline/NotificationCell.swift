//
//  NotificationCell.swift
//  lifeline
//
//  Created by Anjali on 18/08/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var lblNotificationDescription: UILabel!
    @IBOutlet weak var BtnClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    var NotificationListData: MyNotificationModel? {
        didSet
        {
            lblNotificationTitle.text = NotificationListData?.Title
            lblNotificationDescription.text = NotificationListData?.Message
            if NotificationListData?.ReadStatus == 0 {
                viewBackground.backgroundColor = UIColor.white
                lblNotificationTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
                lblNotificationDescription.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
            }else{
                viewBackground.backgroundColor = Util.SharedInstance.hexStringToUIColor(hex: "#d6d2d2 ")
                lblNotificationTitle.font = UIFont(name: "HelveticaNeue", size: 17)
                lblNotificationDescription.font = UIFont(name: "HelveticaNeue", size: 17)
            }
        }
    }
}
