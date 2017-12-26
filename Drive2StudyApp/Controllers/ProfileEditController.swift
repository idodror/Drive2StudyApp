//
//  ProfileEditController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 26/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class ProfileEditController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // SAVE THE DETAILS
        navigationController?.popViewController(animated: true)
    }


}
