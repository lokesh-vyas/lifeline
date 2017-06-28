//
//  LanguageTableCell.swift
//  lifeline
//
//  Created by Anjali on 05/06/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class LanguageTableCell: UITableViewCell {

    @IBOutlet weak var subTitle: UILabel! // languageTitle
    @IBOutlet weak var Lang: UILabel!// languageSubtitle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
