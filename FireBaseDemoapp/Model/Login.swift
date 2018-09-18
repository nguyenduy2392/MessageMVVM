//
//  Login.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/14/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation

class Login {
    private var _email: String = ""
    private var _password: String = ""
    init (email: String, password: String) {
        self._email = email
        self._password = password
    }
    
    var email: String {
        get {
            return _email
        }
    }
    
    var password: String {
        get {
            return _password
        }
    }
}
