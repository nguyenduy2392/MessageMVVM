//
//  Contact.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/13/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation

class Contact {
    private var _name: String = ""
    private var _id: String = ""
    init (id: String, name: String) {
        self._id = id
        self._name = name
    }
    
    var name: String {
        get {
            return _name
        }
    }
    
    var id: String {
        get {
            return _id
        }
    }
}
