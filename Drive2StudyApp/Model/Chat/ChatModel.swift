//
//  ChatModel.swift
//  Drive2StudyApp
//
//  Created by admin on 11/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation
import UIKit

class ChatModel{
    
    static func getAllChatByReceiveIdObserve(receiveName: String) {
        
        print("Model.getAllChatsByReceiveIDAndObserve")
        
        ChatModelFirebase.getAllChatByReceiveIdObserve(receiverID: receiveName, callback: { (list) in
              ModelNotification.ChatList.post(data: list!)
            })
        }
}
