//
//  HomeViewController.swift
//  Integrator
//
//  Created by Eduardo Bocato on 04/02/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var centerLabel: UILabel!
    
    // MARK: - Dependencies
    private let centerLabelText: String
    
    // MARK: - Initialization
    init() {
        self.centerLabelText = "HOME"
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    init(centerLabelText: String) {
        self.centerLabelText = centerLabelText
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerLabel.text = centerLabelText
    }
    
    
}
