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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
