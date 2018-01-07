//
//  RegisterController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class RegisterController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var lNameLabel: UITextField!
    @IBOutlet weak var fNameLabel: UITextField!
    var userEmail:String = ""
    @IBOutlet weak var UserEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    
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
        let encodedUserEmail=userEmail.replacingOccurrences(of: ".", with: ",")
        let st = Student(userName: encodedUserEmail, fName: fNameLabel.text!, lName: lNameLabel.text!, phoneNumber: phoneLabel.text!, study: "", password: passwordLabel.text!, imageUrl: "") //register without image profil
        Model.instance.addStudent(st: Student(st: st))
        Model.studentCurrent = Student(st: st)
        performSegue(withIdentifier: "moveToAppAfterRegister", sender: (Any).self)
    }
}
