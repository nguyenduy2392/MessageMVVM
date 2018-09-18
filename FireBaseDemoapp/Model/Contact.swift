//
//  Contact.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/13/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation

protocol ContactModelPresentable {
  var id: String? { get }
  var name: String? { get }
}

class Contact: ContactModelPresentable {
  var id: String?
  var name: String?
  
  init (id: String, name: String) {
    self.id = id
    self.name = name
  }
}
