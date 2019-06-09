//  
//  GPSearchViewControllerView.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import UIKit

class GPSearchViewControllerView: GPViewController {

    // OUTLETS HERE

    // VARIABLES HERE
    var viewModel = GPSearchViewControllerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewModel()
    }
    
    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {
            if let alert = self.viewModel.alertMessage {
                self.showAlertWithTitleAndMessage(message: alert)
            }
        }
        
        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                self.startViewAnimation()
            } else {
                self.stopViewAnimation()
            }
        }

        self.viewModel.internetConnectionStatus = {
            self.showAlertWithTitleAndMessage(message: "Internet disconnected")
        }

        self.viewModel.serverErrorStatus = {
            self.showAlertWithTitleAndMessage(message: "Server Error / Unknown Error")
        }

        self.viewModel.didGetData = {
            // update UI after get data

        }

    }
    
}


