//
//  ProfileEditController.swift
//  Drive2StudyApp
//
//  Created by IdoD on 26/12/2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit


class ProfileEditController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var iStudyLabel: UITextField!
    
    @IBOutlet weak var sundaySwitch: UISwitch!
    @IBOutlet weak var mondaySwitch: UISwitch!
    @IBOutlet weak var thuesdaySwitch: UISwitch!
    @IBOutlet weak var wednesdaySwitch: UISwitch!
    @IBOutlet weak var thursdaySwitch: UISwitch!
    @IBOutlet weak var fridaySwitch: UISwitch!
    @IBOutlet weak var saturdaySwitch: UISwitch!
    
    var imageUrl:String?
    var selectedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Model.studentCurrent.imageUrl != nil){
            Model.instance.getImage(urlStr: Model.studentCurrent.imageUrl! , callback: { (image) in
                self.userAvatar.image = image
                
            })}
        
        self.loadData();
    }
    
    func loadData() {
        firstNameLabel.text = Model.studentCurrent.fName
        lastNameLabel.text = Model.studentCurrent.lName
        //userAvatar.image = Model.studentCurrent.image //get image by url!
        iStudyLabel.text = Model.studentCurrent.study
        setDaysSwitchStatus()
    }
    
    func setDaysSwitchStatus() {
        var days = Model.studentCurrent.daysInCollege
        if days[0] == 1 { sundaySwitch.isOn = true }
        if days[1] == 1 { mondaySwitch.isOn = true }
        if days[2] == 1 { thuesdaySwitch.isOn = true }
        if days[3] == 1 { wednesdaySwitch.isOn = true }
        if days[4] == 1 { thursdaySwitch.isOn = true }
        if days[5] == 1 { fridaySwitch.isOn = true }
        if days[6] == 1 { saturdaySwitch.isOn = true }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        Model.studentCurrent.fName = firstNameLabel.text!
        Model.studentCurrent.lName = lastNameLabel.text!
        Model.studentCurrent.study = iStudyLabel.text!
        
        
        saveDaysInCollegeNewStatus()
        
        if let image = self.selectedImage{
            Model.instance.saveImage(image: image, name:"image:user:"+Model.studentCurrent.userName){(url) in
                self.imageUrl = url
                Model.studentCurrent.imageUrl = self.imageUrl! //save url to current Student
                Model.instance.addStudent(st: Model.studentCurrent) //+imageUrl
                
            }
        }
        else {
            // to update the data in firebase and in the sqlite db
            Model.instance.addStudent(st: Model.studentCurrent) //
            
        }
        
        let fullNameUpdated = self.firstNameLabel.text! + " " + self.lastNameLabel.text!
        ModelNotification.FullName.post(data: fullNameUpdated)
        print("read from st: \(String(describing: Model.studentCurrent.imageUrl))")
        
        navigationController?.popViewController(animated: true)
    }
    
    func saveDaysInCollegeNewStatus() {
        var days = Model.studentCurrent.daysInCollege
        if sundaySwitch.isOn { days[0] = 1 } else { days[0] = 0 }
        if mondaySwitch.isOn { days[1] = 1 } else { days[1] = 0 }
        if thuesdaySwitch.isOn { days[2] = 1 } else { days[2] = 0 }
        if wednesdaySwitch.isOn { days[3] = 1 } else { days[3] = 0 }
        if thursdaySwitch.isOn { days[4] = 1 } else { days[4] = 0 }
        if fridaySwitch.isOn { days[5] = 1 } else { days[5] = 0 }
        if saturdaySwitch.isOn { days[6] = 1 } else { days[6] = 0 }
        Model.studentCurrent.daysInCollege = days
    }

    @IBAction func changeProfilPictureButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //let image = info["UIImagePickerControllerEditedImage"] as? UIImage
        selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        self.userAvatar.image = selectedImage
        
        self.dismiss(animated: true, completion: nil);
    }
    
}
