//
//  DonateListCell.swift
//  lifeline
//
//  Created by Anjali on 04/08/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class DonateListCell: UITableViewCell {

    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewCamp: UIView!
    @IBOutlet weak var viewHospital: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewBottomForColor: UIView!
    
    @IBOutlet weak var imgDropForTiming: UIImageView!
    @IBOutlet weak var constraintForHeightCamp: NSLayoutConstraint!
    
    @IBOutlet weak var constraintForHeightHospital: NSLayoutConstraint!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTimingForCamp: UILabel!
    @IBOutlet weak var lblTimeForHospital: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
