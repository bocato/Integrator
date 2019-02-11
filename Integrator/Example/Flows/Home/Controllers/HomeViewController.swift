//
//  HomeViewController.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

struct HomeViewControllerDependencies {
    let labelText: String
}

class HomeViewController: UIViewController {

    // MARK: - Dependencies
    
    private let labelText: String
    
    // MARK: - Initialization
    init(labelText: String) {
        self.labelText = labelText
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
