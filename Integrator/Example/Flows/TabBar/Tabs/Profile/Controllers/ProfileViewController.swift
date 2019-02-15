//
//  ProfileViewController.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func showDetailsButtonDidReceiveTouchUpInside()
}

class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    weak var delegate: ProfileViewControllerDelegate?
    
    
    // MARK: - IBActions
    @IBAction func showDetailsButtonDidReceiveTouchUpInside(_ sender: Any) {
        delegate?.showDetailsButtonDidReceiveTouchUpInside()
    }
    
}
