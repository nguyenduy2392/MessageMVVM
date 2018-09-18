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
            if let myContacts = snapshot.value as? NSDictionary {
                for (key, val) in myContacts {
                    if let contactData = val as? NSDictionary {
                        if let email = contactData["email"] as? String{
                            let id = key as! String
                            if id != Auth.auth().currentUser?.uid {
                                let newContact = Contact(id: id, name: email)
                                self.contacts.value.append(newContact)
                            }
                        }
                    }
                }
            }
        }
    }
}
