//
//  ProfileViewController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 26/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var userAvatar: UIImageView!
    
    override func viewDidLoad() {
        ModelNotification.ImgURL.observe { (url) in
            if url != nil && url != "" {
                Model.instance.getImage(urlStr: url! , callback: { (image) in
                    self.userAvatar!.image = image
                })
            }
        }
        
        Model.instance.getImage(urlStr: Model.studentCurrent.imageUrl! , callback: { (image) in
            self.userAvatar!.image = image
        })
        
        
        self.userAvatar.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        self.userAvatar.layer.cornerRadius = 2 * self.userAvatar.bounds.size.width
        self.userAvatar.clipsToBounds = true
        
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    
    func loadData() {
        userNameLabel.text = Model.studentCurrent.fName + " " + Model.studentCurrent.lName
        studyLabel.text = Model.studentCurrent.study
        var list = Model.studentCurrent.daysInCollege
        daysLabel.text = ""
        for i in 0..<list.count{
            if list[i]==1{
                daysLabel.text?+=getDay(i) + "\n"
            }
        }

    }
    
    func getDay(_ day: Int) -> String{
        switch day {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return "NA"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func EditProfileButtonPressed(_ sender: UIButton) {
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
