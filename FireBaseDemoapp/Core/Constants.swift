//
//  Constants.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/18/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation

class Constants {
    static let Message: MessageRow = MessageRow()
    static let MessageTextType = "text"
    static let MessageMediaType = "media"
}

class MessageRow: Constants {
    let SenderId = "senderId"
    let SenderName = "senderName"
    let MessageType = "type"
    let Text = "text"
    let URL = "url"
    let ToId = "toId"
    
}
