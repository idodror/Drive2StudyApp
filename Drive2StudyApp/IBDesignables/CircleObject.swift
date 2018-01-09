//
//  CircleObject.swift
//  Drive2StudyApp
//
//  Created by admin on 09/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import UIKit

class CircleObject{
    
    static func circleImageView (object: UIImageView){
        object.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        object.layer.cornerRadius = 0.5 * object.bounds.size.width
        object.clipsToBounds = true
    }
    static func circleButton (object: UIButton){
        object.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        object.layer.cornerRadius = 0.5 * object.bounds.size.width
        object.clipsToBounds = true
    }
}
