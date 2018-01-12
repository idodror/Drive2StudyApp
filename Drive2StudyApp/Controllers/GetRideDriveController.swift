//
//  GetRideDriveController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 09/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import UIKit

class ShowUserInConnectionsController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    var st: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = st?.userName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
