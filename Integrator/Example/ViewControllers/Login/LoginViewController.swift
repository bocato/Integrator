//
//  LoginViewController.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginDidSucceed(in controller: LoginViewController)
}
class LoginViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: LoginViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions

    @IBAction func doLoginButtonDidReceiveTouchUpInside(_ sender: Any) {
        delegate?.loginDidSucceed(in: self)
    }
    
}
