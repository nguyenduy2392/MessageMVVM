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

class MessageViewModel {
    var messages: BehaviorRelay<[JSQMessage]> = BehaviorRelay(value: [])
    
    func sendMessage(senderId: String, senderName: String, text: String, sendToID: String) {
      DBProvider.Instance.sendMessage(senderId: senderId, senderName: senderName, text: text, sendToID: sendToID)
    }
  
    func sendMediaMessage(senderId: String, senderName: String, url: String, sendToID: String) {
      DBProvider.Instance.sendMediaMessage(senderId: senderId, senderName: senderName, url: url, sendToID: sendToID)
    }
    
    func sendMedia(image: Data?, video: URL?, senderId: String, senderName: String, sendToID: String) {
        let timestamp = NSDate().timeIntervalSince1970
        if image != nil {
          DBProvider.Instance.sendMedia(image: image, video: nil, timestamp: timestamp, senderId: senderId, senderName: senderName, sendToID: sendToID)
        } else if video != nil {
          DBProvider.Instance.sendMedia(image: nil, video: video, timestamp: timestamp, senderId: senderId, senderName: senderName, sendToID: sendToID)
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
                    if message?.type == Constants.messageTextType {
                        messages.append(JSQMessage(senderId: message?.senderId, displayName: message?.senderName, text: message?.text))
                        self.messages.accept(messages)
                    } else if message?.type == Constants.messageMediaType {
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
