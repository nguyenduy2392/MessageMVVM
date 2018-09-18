//
//  ContactViewModel.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/17/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

protocol ContactViewModelDelegate {
    func getContact() -> ()
}

class ContactViewModel {
    var contacts: Variable<[Contact]> = Variable([])
}

extension ContactViewModel: ContactViewModelDelegate {
    func getContact() {
        DBProvider.Instance.contactRef.observeSingleEvent(of: DataEventType.value) { (snapshot: DataSnapshot) in
          guard let myContacts = snapshot.value as? NSDictionary else { return }
          for (key, val) in myContacts {
              guard let contactData = val as? NSDictionary,
                  let email = contactData["email"] as? String,
                  let id = key as? String,
                  id != Auth.auth().currentUser?.uid else { continue }
              let newContact = Contact(id: id, name: email)
              self.contacts.value.append(newContact)
          }
        }
    }
}
