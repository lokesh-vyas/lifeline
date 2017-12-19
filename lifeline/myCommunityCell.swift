//
//  myCommunityCell.swift
//  lifeline
///Users/anjali/Documents/LifeLine/lifeline_iOS/lifeline/myCommunityCell.xib
//  Created by Anjali on 29/11/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class myCommunityCell: UITableViewCell {
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var communityBackgroundView: UIView!
    @IBOutlet weak var lblGroupTitle: UILabel!
    @IBOutlet weak var lblGroupDescription: UILabel!
    @IBOutlet weak var lblClosedGroup: UILabel!
    @IBOutlet weak var lblBloodBank: UILabel!
    @IBOutlet weak var imgDropBlack: UIImageView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var imgPending: UIImageView!
    @IBOutlet weak var imgClosed: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
