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
    private static let instance = DBProvider()
    
    weak var delegate: FetchDataDelegate?
    private init() {}
    
    static var Instance: DBProvider {
        return instance
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
  
  func sendMessage(senderId: String, senderName: String, text: String, sendToID: String) {
    let data: Dictionary<String, Any> = [
      Constants.message.senderId: senderId,
      Constants.message.senderName: senderName,
      Constants.message.messageType: Constants.messageTextType,
      Constants.message.text: text,
      Constants.message.url: "",
      Constants.message.toId: sendToID
    ]
    messagerRef.childByAutoId().setValue(data)
  }
  
  func sendMediaMessage(senderId: String, senderName: String, url: String, sendToID: String) {
    
    let data: Dictionary<String, Any> = [
      Constants.message.senderId: senderId,
      Constants.message.senderName: senderName,
      Constants.message.messageType: Constants.messageMediaType,
      Constants.message.text: "",
      Constants.message.url: url,
      Constants.message.toId: sendToID
    ]
    DBProvider.Instance.messagerRef.childByAutoId().setValue(data)
  }
  
  func sendMedia(image: Data?, video: URL?, timestamp: TimeInterval, senderId: String, senderName: String, sendToID: String) {
      let path = storageRef.child(senderId + "\(timestamp).jpg")
      path.putData(image!, metadata: nil) { (metadata: StorageMetadata?, error: Error?) in
        if error != nil {
          // ERROR
        } else {
          // Fetch the download URL
          path.downloadURL(completion: { (url: URL?, error: Error?) in
            if error != nil {
              // ERROR
            } else {
              self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing: url!), sendToID: sendToID)
            }
          })
        }
      }
  }
}
