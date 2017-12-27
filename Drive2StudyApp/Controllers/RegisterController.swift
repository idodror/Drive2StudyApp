//
//  RegisterController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {

    var userEmail:String = ""
    @IBOutlet weak var UserEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserEmailLabel.text = userEmail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notYourEmailPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        // Check if the register succeeded
        
        // if correct
        performSegue(withIdentifier: "moveToAppAfterRegister", sender: (Any).self)
    }
}
