//
//  RegisterController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lNameLabel: UITextField!
    @IBOutlet weak var fNameLabel: UITextField!
    var userEmail:String = ""
    @IBOutlet weak var UserEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var studyLabel: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Model.studentCurrent.userName == "" {
            self.navigationController?.popToRootViewController(animated: true)
        }
        UserEmailLabel.text = userEmail
        errorLabel.isHidden = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func notYourEmailPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // create user by the details the user entered in the register form
    @IBAction func joinButtonPressed(_ sender: UIButton) {
       
        Auth.auth().createUser(withEmail: userEmail, password: passwordLabel.text!, completion: {(user,error) in
            if (error==nil){
                print("user created successfully")
                let encodedUserEmail = self.userEmail.replacingOccurrences(of: ".", with: ",")
                let st = Student(userName: encodedUserEmail, fName: self.fNameLabel.text!, lName: self.lNameLabel.text!, study: self.studyLabel.text!, imageUrl: "", LoginType: "RegularLogin") //register without image profile
                Model.instance.addStudent(st: Student(st: st))
                Model.studentCurrent = Student(st: st)
                self.moveToNextPage(string: "moveToAppAfterRegister")
            }
            else{
                self.errorLabel.text! = "error creating new user"
                self.errorLabel.isHidden = false
            }
        })
    }
    
    func moveToNextPage(string: String){
        performSegue(withIdentifier: string , sender: (Any).self)
    }
}
