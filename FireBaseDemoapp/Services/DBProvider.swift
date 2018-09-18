//
//  DBProvider.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/13/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

protocol FetchDataDelegate: class {
    func dataReceived(contacts: [Contact])
}

class DBProvider {
    private static let _instance = DBProvider()
    
    weak var delegate: FetchDataDelegate?
    private init() {}
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var contactRef: DatabaseReference {
        return dbRef.child("users")
    }
    
    var messagerRef: DatabaseReference {
        return dbRef.child("Messages")
    }
    
    var messagerMediaRef: DatabaseReference {
        return dbRef.child("MessagesMedia")
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://fir-demo-f81d5.appspot.com")
    }
    
    var imageStorageRef: StorageReference {
        return storageRef.child("Images")
    }
    
    var videoStorageRef: StorageReference {
        return storageRef.child("Videos")
    }
    
    func saveUser(id: String, email: String, password: String) {
        let data: Dictionary<String, Any> = ["email": email, "password": password]
        contactRef.child(id).setValue(data)
    }
}
