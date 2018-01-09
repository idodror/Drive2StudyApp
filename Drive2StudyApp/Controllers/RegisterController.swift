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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Model.studentCurrent.userName == "" {
            self.navigationController?.popToRootViewController(animated: true)
        }
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
        let st = Student(userName: encodedUserEmail, fName: fNameLabel.text!, lName: lNameLabel.text!, study: studyLabel.text!, imageUrl: "", LoginType: "RegularLogin") //register without image profile
        Model.instance.addStudent(st: Student(st: st))
        Model.studentCurrent = Student(st: st)
        Auth.auth().createUser(withEmail: userEmail, password: passwordLabel.text!, completion: {(user,error) in
            if (error==nil){
                print("user created successfully")
                self.moveToNextPage(string: "moveToAppAfterRegister")
            }
            else{
                print("error creating new user")
            }
        })
    }
    
    func moveToNextPage(string: String){
        performSegue(withIdentifier: string , sender: (Any).self)
    }
}
