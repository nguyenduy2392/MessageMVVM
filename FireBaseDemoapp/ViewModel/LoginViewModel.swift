//
//  Login.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/14/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
//import FBSDKLoginKit

class LoginViewModel {
    var email: Variable<String> = Variable("")
    var password: Variable<String> = Variable("")
    var invalidLogin: Variable<Bool> = Variable(false)
    
    func registerModel() {
        Auth.auth().createUser(withEmail: self.email.value, password: self.password.value) { (authResult, error) in
            guard let user = authResult?.user else {
                self.invalidLogin.value = false
                return
            }
            
            DBProvider.Instance.saveUser(id: user.uid, email: user.email!, password: self.password.value)
            self.invalidLogin.value = true
        }
    }
    
    func loginModel() {
        Auth.auth().signIn(withEmail: self.email.value, password: self.password.value) { (user, error) in
            if error != nil {
                self.invalidLogin.value = false
                return
            }
            self.invalidLogin.value = true
        }
    }
}
