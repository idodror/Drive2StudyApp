//
//  ForgotPasswordController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 23/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

protocol ForgotPasswordControllerDelegate {
    
}

class ForgotPasswordController: UIViewController{
    

    var userPhone:String = ""
    var delegate: ForgotPasswordControllerDelegate?
    @IBOutlet weak var userPhoneLabel: UILabel!
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
        
       userPhoneLabel.text = userPhone
    }

    @IBAction func SendNowButtonPressed(_ sender: UIButton) {
        
        
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
