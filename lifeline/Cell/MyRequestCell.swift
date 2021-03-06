//
//  MyRequestCell.swift
//  lifeline
//
//  Created by iSteer on 25/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyRequestCell: UITableViewCell {

    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblRequestDate: UILabel!
    @IBOutlet weak var btnCloseRequest: UIButton!
    @IBOutlet weak var btnViewDonars: UIButton!
    @IBOutlet weak var viewColorForStatus: UIView!
    @IBOutlet weak var viewCloseButtonRequest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
