//
//  ChooseLocationViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 28/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class ChooseLocationViewController: UIViewController {
    
    @IBOutlet weak var LocationLabel: UITextField!
    var type:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButtonPressed(_ sender: UIButton) {
        let dr = DriveRide(userName: Model.studentCurrent.userName, fromWhere: LocationLabel.text!, type: type)
        Model.instance.addNewDriveRide(dr: dr)
        self.dismiss(animated: true, completion: nil)
    }
    
}
