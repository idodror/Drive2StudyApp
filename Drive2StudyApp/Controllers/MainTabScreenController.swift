//
//  MainTabScreenController.swift
//  Drive2StudyApp
//
//  Created by delver on 25.12.2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth

// To apply background color on stack view
public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

// this class rperesent the custom tabs view of the application
class MainTabScreenController: UIViewController {
    
    var childControllersNames = [
        "GoogleMapViewController",
        "DriveViewController",
        "RideViewController",
        "ChatNavigation",
        "ProfileNavigation",]
    
    var childControllers = Array<UIViewController>()

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var driveButton: UIButton!
    @IBOutlet weak var rideButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet private weak var topStackView: UIStackView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAvatar: UIButton!
    
    // background to UIView
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // set the background to a specific UIView
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
    
    override func viewDidLoad() {
        

        CircleObject.circleButton(object: userAvatar)

        _ = ModelNotification.ImgURL.observe { (url) in
            if url != nil && url != "" {
                Model.instance.getImage(urlStr: url! , callback: { (image) in
                    
                    //self.userAvatar.setBackgroundImage(image, for: .highlighted)
                    self.userAvatar.setImage(image, for: .normal)
                })
            }
        }
        _ = ModelNotification.FullName.observe{ (fullName) in
            self.userNameLabel.text = fullName
        }
        super.viewDidLoad()
        for vcn in childControllersNames{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:vcn)
            childControllers.append(vc)
            addChildViewController(vc)
        }
        
        self.mapButton.setImage(UIImage(named: "mapMarkerBlue"), for: .normal)
        self.viewContainer.addSubview(childControllers[0].view)
        pinBackground(backgroundView, to: topStackView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameLabel.text = Model.studentCurrent.fName + " " + Model.studentCurrent.lName
        
        
        if(Model.studentCurrent.imageUrl != nil){
            Model.instance.getImage(urlStr: Model.studentCurrent.imageUrl! , callback: { (image) in
                self.userAvatar.setImage(image, for: .normal)
                
            })}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for vc in childControllers{
            vc.view.frame = viewContainer.frame
            vc.view.frame.origin = CGPoint(x:0,y:0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MapButtonPressed(_ sender: UIButton) {
        self.mapButton.setImage(UIImage(named: "mapMarkerBlue"), for: .normal)
        self.driveButton.setImage(UIImage(named: "driveMarkerBlack"), for: .normal)
        self.rideButton.setImage(UIImage(named: "rideMarkerBlack"), for: .normal)
        self.chatButton.setImage(UIImage(named: "chatMarkerBlack"), for: .normal)
        
        self.viewContainer.addSubview(childControllers[0].view)
    }
    
    @IBAction func DriveButtonPressed(_ sender: UIButton) {
        self.driveButton.setImage(UIImage(named: "driveMarkerBlue"), for: .normal)
        self.mapButton.setImage(UIImage(named: "mapMarkerBlack"), for: .normal)
        self.rideButton.setImage(UIImage(named: "rideMarkerBlack"), for: .normal)
        self.chatButton.setImage(UIImage(named: "chatMarkerBlack"), for: .normal)
        
        self.viewContainer.addSubview(childControllers[1].view)
    }
    
    @IBAction func RideButtonPressed(_ sender: UIButton) {
        self.rideButton.setImage(UIImage(named: "rideMarkerBlue"), for: .normal)
        self.mapButton.setImage(UIImage(named: "mapMarkerBlack"), for: .normal)
        self.driveButton.setImage(UIImage(named: "driveMarkerBlack"), for: .normal)
        self.chatButton.setImage(UIImage(named: "chatMarkerBlack"), for: .normal)
        
        self.viewContainer.addSubview(childControllers[2].view)
    }
    
    @IBAction func ChatButtonPressed(_ sender: UIButton) {
        self.chatButton.setImage(UIImage(named: "chatMarkerBlue"), for: .normal)
        self.mapButton.setImage(UIImage(named: "mapMarkerBlack"), for: .normal)
        self.driveButton.setImage(UIImage(named: "driveMarkerBlack"), for: .normal)
        self.rideButton.setImage(UIImage(named: "rideMarkerBlack"), for: .normal)
        
        
        self.viewContainer.addSubview(childControllers[3].view)
    }
    
    @IBAction func ProfileViewButtonPressed(_ sender: UIButton) {
        self.viewContainer.addSubview(childControllers[4].view)
    }
    
    @IBAction func SignoutButtonPressed(_ sender: UIButton) {
        
        if(Model.studentCurrent.LoginType == "FB"){
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
            fbLoginManager.logOut()
            
        }
            do{
            try Auth.auth().signOut()
            }catch{
                print("Error signing out from Firebase")
            }
        
        Model.studentCurrent = Student()
        self.dismiss(animated: true, completion: nil)
        
    }
}
