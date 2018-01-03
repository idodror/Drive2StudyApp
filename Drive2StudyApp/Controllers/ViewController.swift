//
//  ViewController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SigninWithEmailControllerDelegate {

    @IBOutlet weak var UserEmailLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = ModelFirebase()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let text = UserEmailLabel.text!
        if segue.identifier == "moveToSignInPage" {
            let destViewController = segue.destination as! SigninWithEmailContoller
            destViewController.userEmail = text
            destViewController.delegate = self
        }
        if segue.identifier == "moveToRegisterPage" {
            let destViewController = segue.destination as! RegisterController
            destViewController.userEmail = text
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func continueWithEmailPressed(_ sender: UIButton) {
        let text = UserEmailLabel.text!
        Model.instance.getStudentById(id: text) { (student) in
            if (student != nil) {
                // save to sqlite
                self.goToNextPage(isRegisterd: "true")
            } else {
                self.goToNextPage(isRegisterd: "false")
            }
        }
    }
    
    func goToNextPage(isRegisterd: String) {
        if (isRegisterd == "true") {
            performSegue(withIdentifier: "moveToSignInPage", sender: Any?.self)
        } else {
            performSegue(withIdentifier: "moveToRegisterPage", sender: Any?.self)
        }
    }
    
}

