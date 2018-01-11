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
}
