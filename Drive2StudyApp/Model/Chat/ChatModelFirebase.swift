//
//  ChatModelFirebase.swift
//  Drive2StudyApp
//
//  Created by delver on 11.1.2018.
//  Copyright © 2018 IdoD. All rights reserved.
//

import Firebase

struct ChatModelFirebase
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
    

    
    static func getAllChatByReceiveIdObserve(receiverID: String, callback:@escaping ([ChatMessage]?)->Void){
        let myRef = Database.database().reference().child("chats")
        var str1: String?
        myRef.observe(.value, with: { (snapshot) in
            if let values = snapshot.value as? [String:[String:Any]]{
                
                var chatArray = [ChatMessage]()
                for chatJson in values{
                    print("-----------------------")
                    for relevantJson in chatJson.value
                    {
                        print("\(relevantJson.value)")
                        str1 = String(describing: relevantJson.value)
                        if(relevantJson.key == "receiver_id" && str1 == receiverID){
                            let chat = ChatMessage(json: chatJson.value)
                            chatArray.append(chat)
                        }
                    }
                }

                callback(chatArray)
            }else{
                callback(nil)
            }
        })
    }
    
    static func RemoveMessage(chat: ChatMessage){
        let myRef = Database.database().reference().child("chats").childByAutoId().child(chat.receiver_id)
        myRef.removeValue()
    }
    
    

}
