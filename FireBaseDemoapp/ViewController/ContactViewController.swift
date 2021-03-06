//
//  HomeViewController.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/12/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

class ContactViewController: UIViewController {

    @IBOutlet weak var contactTableView: UITableView!
    var sendToID: String!
    
    var contactModel = ContactViewModel()
  let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        contactModel.getContact()
        
        let nid = UINib(nibName: "UserTableViewCell", bundle: nil)
        contactTableView.register(nid, forCellReuseIdentifier: "UserTableViewCell")
        
        _ = self.contactModel.contacts.asObservable().bind(to: contactTableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) {row, item, cell in
          cell.configure(name: item.name!)
        }
      
      contactTableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
          self?.sendToID = self?.contactModel.contacts.value[indexPath.row].id
          self?.performSegue(withIdentifier: "ChatRoom", sender: nil)
        }).disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ContactViewController: UITableViewDelegate {
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ChatRoom") {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ChatRoomViewController
            vc.sendToID = self.sendToID
        }
    }
}
