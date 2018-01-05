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
    @IBOutlet weak var phoneNumberLabel: UITextField!
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
        firstNameLabel.text = Model.studentCurrent.fName
        lastNameLabel.text = Model.studentCurrent.lName
        phoneNumberLabel.text = Model.studentCurrent.phoneNumber
        //userAvatar.image = Model.studentCurrent.image //get image by url!
        iStudyLabel.text = Model.studentCurrent.study
        //days
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let image = self.selectedImage{
            Model.instance.saveImage(image: image, name:self.firstNameLabel.text!){(url) in
                self.imageUrl = url
            }
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func changeProfilPictureButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
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
