//
//  Constants.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/18/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation

class Constants {
    static let message: MessageRow = MessageRow()
    static let messageTextType = "text"
    static let messageMediaType = "media"
}

class MessageRow: Constants {
    let senderId = "senderId"
    let senderName = "senderName"
    let messageType = "type"
    let text = "text"
    let url = "url"
    let toId = "toId"
    
}
