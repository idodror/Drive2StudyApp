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
            if (list != nil){
              ModelNotification.ChatList.post(data: list!)
            }
            else{
                print("No messages found for current student")
            }
            })
        }
    
    static func RemoveMessage(chat: ChatMessage){
        ChatModelFirebase.RemoveMessage(chat: chat)
    }
}
