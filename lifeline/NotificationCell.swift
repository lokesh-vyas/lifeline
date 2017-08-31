//
//  NotificationCell.swift
//  lifeline
//
//  Created by Anjali on 18/08/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblNotificationTitle: UILabel!
    
    @IBOutlet weak var lblNotificationDescription: UILabel!
    
    @IBOutlet weak var PendingImage: UIImageView!
    
    @IBOutlet weak var CloseBtnView: UIImageView!
    
    @IBOutlet weak var BtnClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
