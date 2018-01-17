//
//  ForgotPasswordController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol ForgotPasswordControllerDelegate {
    
}

class ForgotPasswordController: UIViewController{
    
    @IBOutlet weak var UserEmailLabel: UILabel!
    
    var userEmail:String = ""
    var delegate: ForgotPasswordControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trySigninAgainPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
       UserEmailLabel.text = userEmail
    }

    // sends recover password email (from firebase database)
    @IBAction func SendNowButtonPressed(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: userEmail, completion:{(error) in
            if error == nil{
                print("An email was sent")
            self.navigationController?.popViewController(animated: true)
            }
            else{
                print("error")
            }
        })
    }
    
  

}
