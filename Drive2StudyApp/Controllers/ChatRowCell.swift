//
//  ChatRowCell.swift
//  Drive2StudyApp
//
//  Created by delver on 11.1.2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import UIKit

class ChatRowCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    
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


