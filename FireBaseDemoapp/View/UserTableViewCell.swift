//
//  UserTableViewCell.swift
//  FireBaseDemoapp
//
//  Created by duy on 9/13/18.
//  Copyright © 2018 app1 name. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(name: String) {
        self.userNameLable.text = name
    }
    
}
