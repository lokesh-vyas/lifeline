//
//  MyDonorCell.swift
//  lifeline
//
//  Created by iSteer on 01/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class MyDonorCell: UITableViewCell {

    @IBOutlet weak var lblDonorName: UILabel!
    @IBOutlet weak var imgCloseView: UIImageView!
    @IBOutlet weak var btnCallTapped: UIButton!
    @IBOutlet weak var viewColorStatus: UIView!
    @IBOutlet weak var btnCloseTapped: UIButton!
    @IBOutlet weak var btnEmailTapped: UIButton!
    @IBOutlet weak var lblDonorContactNumber: UILabel!
    @IBOutlet weak var lblDonorEmail: UILabel!
    @IBOutlet weak var lblDonorTime: UILabel!
    @IBOutlet weak var lblDonorComment: UILabel!
    @IBOutlet weak var imgDonorComment: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
