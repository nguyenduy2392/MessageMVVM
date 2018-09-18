//
//  MessagersHandler.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/14/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase
import RxSwift
import RxCocoa
import JSQMessagesViewController
import ObjectMapper

class MessageHandler {
    var messages: BehaviorRelay<[JSQMessage]> = BehaviorRelay(value: [])
    
    func sendMessage(senderId: String, senderName: String, text: String, sendToID: String) {
        let data: Dictionary<String, Any> = [
            Constants.Message.SenderId: senderId,
            Constants.Message.SenderName: senderName,
            Constants.Message.MessageType: Constants.MessageTextType,
            Constants.Message.Text: text,
            Constants.Message.URL: "",
            Constants.Message.ToId: sendToID
        ]
        DBProvider.Instance.messagerRef.childByAutoId().setValue(data)
    }
    
    func sendMediaMessage(senderId: String, senderName: String, url: String, sendToID: String) {
        
        let data: Dictionary<String, Any> = [
            Constants.Message.SenderId: senderId,
            Constants.Message.SenderName: senderName,
            Constants.Message.MessageType: Constants.MessageMediaType,
            Constants.Message.Text: "",
            Constants.Message.URL: url,
            Constants.Message.ToId: sendToID
        ]
        DBProvider.Instance.messagerRef.childByAutoId().setValue(data)
    }
    
    func sendMedia(image: Data?, video: URL?, senderId: String, senderName: String, sendToID: String) {
        let timestamp = NSDate().timeIntervalSince1970
        if image != nil {
            let path = DBProvider.Instance.storageRef.child(senderId + "\(timestamp).jpg")
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
        } else if video != nil {
            let path = DBProvider.Instance.storageRef.child(senderId + "\(timestamp).mp4")
            path.putFile(from: video!, metadata: nil) { (metadata: StorageMetadata?, error: Error?) in
                if error != nil {
                    
                } else {
                    
                    path.downloadURL(completion: { (url: URL?, error: Error?) in
                        if error != nil {
                            // ERROR
                        } else {
                            self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing: url!), sendToID: sendToID)
                        }
                    })
                }
            }
        } else {
            return
        }
    }
    
    func observerMessages(sendToID: String) {
        var messages: [JSQMessage] = []
        DBProvider.Instance.messagerRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                let jsonData = try? JSONSerialization.data(withJSONObject: data, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                let message = MessageModel(JSONString: jsonString!)
                if (sendToID == message?.toId && message?.senderId == Auth.auth().currentUser?.uid) || (message?.toId == Auth.auth().currentUser?.uid && sendToID == message?.senderId) {
                    if message?.type == Constants.MessageTextType {
                        messages.append(JSQMessage(senderId: message?.senderId, displayName: message?.senderName, text: message?.text))
                        self.messages.accept(messages)
                    } else if message?.type == Constants.MessageMediaType {
                        DispatchQueue(label: "load").async {
                            do {
                                let data = try Data(contentsOf: URL(string: (message?.url)!)!)
                                let dataImage = UIImage(data: data)
                                let img = JSQPhotoMediaItem(image: dataImage)
                                messages.append(JSQMessage(senderId: message?.senderId, displayName: message?.senderName, media: img))
                                self.messages.accept(messages)
                            } catch {
                                // ERROR
                            }
                        }
                    }
                }
            }
        }
    }
    
    func removeObserve() {
        DBProvider.Instance.messagerRef.removeAllObservers()
        self.messages.accept([])
    }
}
