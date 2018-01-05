//
//  MainTabScreenController.swift
//  Drive2StudyApp
//
//  Created by delver on 25.12.2017.
//  Copyright © 2017 IdoD. All rights reserved.
//

import UIKit

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

class MainTabScreenController: UIViewController {
    
    var childControllersNames = [
        "MapViewController",
        "DriveViewController",
        "RideViewController",
        "ChatNavigation",
        "ProfileNavigation",
        "ConnectionViewController"]
    
    var childControllers = Array<UIViewController>()

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet private weak var topStackView: UIStackView!
    @IBOutlet weak var userNameLabel: UILabel!
    
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
        super.viewDidLoad()
        for vcn in childControllersNames{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:vcn)
            childControllers.append(vc)
            addChildViewController(vc)
        }
        userNameLabel.text = Model.studentCurrent.fName + " " + Model.studentCurrent.lName
        self.viewContainer.addSubview(childControllers[0].view)
        pinBackground(backgroundView, to: topStackView)
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
    
    @IBAction func ProfileViewButtonPressed(_ sender: UIButton) {
        self.viewContainer.addSubview(childControllers[4].view)
    }
    
    @IBAction func connectionButtonPressed(_ sender: Any) {
        self.viewContainer.addSubview(childControllers[5].view)
    }
    
    @IBAction func SignoutButtonPressed(_ sender: UIButton) {
        Model.studentCurrent = Student()
        self.dismiss(animated: true, completion: nil)
    }
}
