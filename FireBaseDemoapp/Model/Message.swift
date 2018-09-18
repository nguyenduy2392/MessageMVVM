//
//  Message.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/18/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MessageModelPresentable {
    var senderId: String? { get }
    var senderName: String? { get }
    var type: String? {get}
    var text : String? {get}
    var url : String? {get}
    var toId : String? {get}
}

struct MessageModel : Mappable, MessageModelPresentable {
    
    init() {
        self.senderId = ""
        self.senderName = ""
        self.type = ""
        self.text = ""
        self.url = ""
        self.toId = ""
    }
    
    init?(map: Map) {
        
    }
    
    
    var senderId : String?
    var senderName: String?
    var type : String?
    var text : String?
    var url : String?
    var toId : String?
    
    
    mutating func mapping(map: Map) {
        senderId <- map["senderId"]
        senderName <- map["senderName"]
        type <- map["type"]
        text <- map["text"]
        url <- map["url"]
        toId <- map["toId"]
    }
}
