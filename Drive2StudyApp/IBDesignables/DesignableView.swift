//
//  DesignableView.swift
//  Drive2StudyApp
//
//  Created by admin on 28/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}
