//
//  MainTabScreenController.swift
//  Drive2StudyApp
//
//  Created by delver on 25.12.2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

class MainTabScreenController: UIViewController {
    
    var childControllersNames = [
        "MapViewController",
        "DriveViewController",
        "RideViewController",
        "ChatViewController"]
    
    var childControllers = Array<UIViewController>()

    @IBOutlet weak var viewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for vcn in childControllersNames{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:vcn)
            childControllers.append(vc)
            addChildViewController(vc)
        }
        self.viewContainer.addSubview(childControllers[0].view)
        
        // Do any additional setup after loading the view.
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
        self.viewContainer.addSubview(childControllers[0].view)
    }
    
    @IBAction func DriveButtonPressed(_ sender: UIButton) {
        
        self.viewContainer.addSubview(childControllers[1].view)
    }

    @IBAction func RideButtonPressed(_ sender: UIButton) {
        self.viewContainer.addSubview(childControllers[2].view)
    }
    
    @IBAction func ChatButtonPressed(_ sender: UIButton) {
        self.viewContainer.addSubview(childControllers[3].view)
    }
    

}
