//
//  ViewController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import FacebookLogin
import Firebase
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, SigninWithEmailControllerDelegate{
    
    @IBOutlet weak var UserEmailLabel: UITextField!
    @IBOutlet weak var InvalidEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = ModelFirebase()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Facebook Login
        
        /*let FBLoginBtn = LoginButton(readPermissions: [.publicProfile])
        FBLoginBtn.delegate = self
        FBLoginBtn.center = view.center
        
        view.addSubview(FBLoginBtn)*/
        
    }
    
    
    @IBAction func ConnectWithFBButtonPressed(_ sender: UIButton) {
    
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signIn(with: credential)
                    self.getFBUserData()
                }
            }
        }
    }
    
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error != nil){
                    //everything works print the user data
                    print("Error occured")
                }
                else{
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    let email = data["email"]!
                    Model.instance.getStudentById(id: email as! String) { (student) in
                    if(student != nil){
                        // save to sqlite
                        Model.instance.addNewStudentToLocalDB(st: student!)
                        Model.studentCurrent = Student(st: student!)
                    }
                    else{
                        let encodedUserEmail=email.replacingOccurrences(of: ".", with: ",")
                        
                        
                        let st = Student(userName: encodedUserEmail, fName: data["first_name"]! as! String, lName: data["last_name"]! as! String, study: "", imageUrl: "", LoginType: "FB") //register without image profile
                        Model.instance.addStudent(st: Student(st: st))
                        Model.studentCurrent = Student(st: st)
                        
                        
                        //get profile image
                        let FBid = data["id"] as? String
                        let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                       let image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                        Model.instance.saveImage(image: image!, name:"image:user:"+Model.studentCurrent.userName){(url) in
                                Model.studentCurrent.imageUrl = url //save url to current Student
                                Model.instance.addStudent(st: Model.studentCurrent) //+imageUrl
                                
                            }
                        
                    }
                        self.goToNextPage(page: "MoveToAfterFBSignIn")
                    }
                }
            })
        }
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
            Model.studentCurrent.userName = text
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func continueWithEmailPressed(_ sender: UIButton) {
        let text = UserEmailLabel.text!
        if text != "" {
            if (isValidEmail(testStr:text)) {
                Model.instance.getStudentById(id: text) { (student) in
                    if (student != nil) {
                        // save to sqlite
                        Model.instance.addNewStudentToLocalDB(st: student!)
                        Model.studentCurrent = Student(st: student!)
                        self.goToNextPage(page: "moveToSignInPage")
                    } else {
                        self.goToNextPage(page: "moveToRegisterPage")
                    }
                }
            } else {
                InvalidEmailLabel!.text = "Invalid Email"
                InvalidEmailLabel!.isHidden = false
            }
        } else {
            InvalidEmailLabel!.text = "Email can't be empty"
            InvalidEmailLabel!.isHidden = false
        }
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func goToNextPage(page: String) {
            performSegue(withIdentifier: page, sender: Any?.self)
    }
    

}
