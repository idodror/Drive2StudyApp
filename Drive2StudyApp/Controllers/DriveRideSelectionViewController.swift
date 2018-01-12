//
//  DriveRideSelectionViewController.swift
//  Drive2StudyApp
//
//  Created by admin on 12/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import UIKit

class DriveRideSelectionViewController: UIViewController {

    @IBOutlet weak var profilPicture: UIImageView!
    var type: String?
    var selctedDriverRow:DriveRowCell?
    var selctedRiderRow:RideRowCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilPicture.frame = CGRect(x: 157, y: 136, width: 50, height: 50)
        profilPicture.layer.cornerRadius = 0.5 * profilPicture.bounds.size.width
        profilPicture.clipsToBounds = true
        
        profilPicture.image = selctedDriverRow?.profilePicture.image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissPopup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
