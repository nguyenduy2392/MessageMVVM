//
//  LoginViewController.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/18/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLable: UILabel!
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle?
    var loginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = emailTextField.rx.text
            .map {$0 ?? ""}
            .bind(to: loginViewModel.email)
        _ = passwordTextField.rx.text
            .map {$0 ?? ""}
            .bind(to: loginViewModel.password)
        
        _ = loginViewModel.invalidLogin.asObservable().subscribe(onNext: {[weak self] isValid in
            if isValid {
                self?.performSegue(withIdentifier: "ContactsSegue", sender: nil)
            } else {
                // Error
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        self.loginViewModel.registerModel()
    }
    
    @IBAction func login(_ sender: Any) {
        self.loginViewModel.loginModel()
    }
}

