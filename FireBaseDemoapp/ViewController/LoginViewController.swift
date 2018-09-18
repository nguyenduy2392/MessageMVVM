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
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLable: UILabel!
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle?
    var loginViewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = emailText.rx.text
            .map {$0 ?? ""}
            .bind(to: loginViewModel.email)
        _ = passwordText.rx.text
            .map {$0 ?? ""}
            .bind(to: loginViewModel.password)
        
        _ = loginViewModel.invalidLogin.asObservable().subscribe(onNext: {[weak self] val in
            if val {
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

