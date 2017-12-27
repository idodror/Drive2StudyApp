//
//  SigninWithEmailContoller.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

protocol SigninWithEmailControllerDelegate {
    
}

class SigninWithEmailContoller: UIViewController {

    var userEmail:String = ""
    var delegate: SigninWithEmailControllerDelegate?
    @IBOutlet weak var UserEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserEmailLabel.text = userEmail
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notYourEmailPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        // Check if the password is correct
        
        // if correct
        // if correct
        performSegue(withIdentifier: "moveToAppAfterSignIn", sender: (Any).self)
    }

}
