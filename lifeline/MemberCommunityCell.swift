//
//  MemberCommunityCell.swift
//  lifeline
//
//  Created by Anjali on 08/01/18.
//  Copyright © 2018 iSteer. All rights reserved.
//

import UIKit

class MemberCommunityCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var constraintForHorizontalSpace: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
