//
//  ViewController.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.perform(#selector(showMainView), with: nil, afterDelay: 0.1)
    }
    
    @objc func showMainView() {
        UIApplication.shared.delegate?.window??.rootViewController = UINavigationController.init(rootViewController: GPSearchViewControllerView())
    }

}

