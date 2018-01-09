//
//  DriveRowCell.swift
//  Drive2StudyApp
//
//  Created by IdoD on 08/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import UIKit

class DriveRowCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var fromWhereLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CircleObject.circleImageView(object: profilePicture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
