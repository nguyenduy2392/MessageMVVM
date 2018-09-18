//
//  Login.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/14/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation

protocol LoginModelPresentable {
  var email: String? { get }
  var password: String? { get }
}

class Login {
    var email: String?
    var password: String?
    init (email: String, password: String) {
        self.email = email
        self.password = password
    }
}
