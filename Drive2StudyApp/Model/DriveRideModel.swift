//
//  DriveRideModel.swift
//  Drive2StudyApp
//
//  Created by IdoD on 05/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import UIKit

class DriveRideModel {
    func addStudent(dr:DriveRide){
        DriveRideModelFirebase.addNewDrive(dr: dr) { (error) in
            //st.addStudentToLocalDb(database: self.modelSql?.database)
        }
        //st.addStudentToLocalDb(database: self.modelSql?.database)
    }
}
