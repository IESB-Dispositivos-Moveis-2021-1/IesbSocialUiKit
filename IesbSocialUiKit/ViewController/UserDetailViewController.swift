//
//  UserDetailViewController.swift
//  IesbSocialUiKit
//
//  Created by Pedro Henrique on 16/09/21.
//

import UIKit

class UserDetailViewController: UIViewController {

    var user: User?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = user {
            navigationItem.title = user.name
        }
    }
    
}
