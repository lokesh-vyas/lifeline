//
//  MyDonationCell.swift
//  lifeline
//
//  Created by Anjali on 09/10/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyDonationCell: UITableViewCell {
    @IBOutlet weak var lblCampHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblRequestDate: UILabel!
    @IBOutlet weak var imgBloodGroup: UIImageView!
    @IBOutlet weak var imgCamp: UIImageView!
    @IBOutlet weak var lblCamp: UILabel!
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
