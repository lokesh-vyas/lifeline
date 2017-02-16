//
//  HospitalListCell.swift
//  lifeline
//
//  Created by iSteer on 16/02/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class HospitalListCell: UITableViewCell {
    @IBOutlet weak var lblHospitalName: UILabel!

    @IBOutlet weak var lblCityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
