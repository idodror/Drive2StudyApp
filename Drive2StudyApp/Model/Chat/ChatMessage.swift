//
//  ChatMessage.swift
//  Drive2StudyApp
//
//  Created by admin on 11/01/2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Foundation

// This object represent the chat messages
class ChatMessage{
    
    var name: String
    var receiver_id: String
    var sender_id: String
    var text:String
    
    init(){
        self.name = ""
        self.receiver_id = ""
        self.sender_id = ""
        self.text = ""
    }
    
    init(name: String, receiver: String, sender: String, text: String) {
        self.name = name
        self.receiver_id = receiver
        self.sender_id = sender
        self.text = text
    }
    
    init(chat: ChatMessage){
        self.name = chat.name
        self.receiver_id = chat.receiver_id
        self.sender_id = chat.sender_id
        self.text = chat.text
    }
    
    init(json:Dictionary<String,Any>){
        name = json["name"] as! String
        receiver_id = json["receiver_id"] as! String
        sender_id = json["sender_id"] as! String
        text = json["text"] as! String
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["name"] = name
        json["receiver_id"] = receiver_id
        json["sender_id"] = sender_id
        json["text"] = text
        return json
    }
    
}
