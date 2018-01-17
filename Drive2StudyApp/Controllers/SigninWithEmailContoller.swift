//
//  SigninWithEmailContoller.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol SigninWithEmailControllerDelegate {
    
}

class SigninWithEmailContoller: UIViewController, ForgotPasswordControllerDelegate {

    var userEmail:String = ""
    var password:String = ""
    var delegate: SigninWithEmailControllerDelegate?
    @IBOutlet weak var UserEmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UITextField!
    @IBOutlet weak var WrongPassLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Model.studentCurrent.userName == "" {
            self.navigationController?.popToRootViewController(animated: true)
        }
        UserEmailLabel.text = userEmail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let text = userEmail
        if segue.identifier == "moveToForgotPassword" {
            let destViewController = segue.destination as! ForgotPasswordController
            destViewController.userEmail = text
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notYourEmailPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
    }
    
    // if sign in pressed, check by authentication the password and sign in the user (or not)
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        // Check if the password is correct
        password = PasswordLabel.text!
         Auth.auth().signIn(withEmail: userEmail, password: password, completion: {(user,error) in
            if error == nil{
                print("user signed in")
                self.moveToNextPage(page: "moveToAppAfterSignIn")
            }
            else
            {
                print("error signing in")
                self.WrongPassLabel!.isHidden = false
            }
         })
        }

    // moves to forgot password view controller
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
        self.moveToNextPage(page: "moveToForgotPassword")
        
    }
    
    func moveToNextPage(page: String){
        performSegue(withIdentifier: page, sender: (Any).self)
    }
}
