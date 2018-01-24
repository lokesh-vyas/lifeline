//
//  AdminInviteCell.swift
//  lifeline
//
//  Created by Anjali on 12/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit

class AdminInviteCell: UITableViewCell {
    @IBOutlet weak var btnCancelInvite: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
