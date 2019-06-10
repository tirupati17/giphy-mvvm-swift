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
        
        let vc = GPSearchViewControllerView()
        let nv = UINavigationController.init(rootViewController: vc)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.present(nv, animated: true, completion: nil)
        }
    }

}

