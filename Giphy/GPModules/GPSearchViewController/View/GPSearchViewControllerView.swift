//  
//  GPSearchViewControllerView.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import UIKit

let searchViewControllerViewCellId = "GPSearchViewControllerViewCellId"

class GPSearchViewControllerView: GPViewController {

    var tableView : UITableView = UITableView()
    var isUpdatedConstraints: Bool? = false

    var viewModel = GPSearchViewControllerViewModel()
    override func loadView() {
        super.loadView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GPSearchListCell.self, forCellReuseIdentifier: searchViewControllerViewCellId)
        
        tableView.sectionIndexColor = .darkGray
        tableView.sectionIndexBackgroundColor = .clear
        tableView.refreshControl = self.refreshControl
        
        view.addSubview(tableView)
        self.setupConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewModel()
        self.viewModel.bindSearchImage(query: "cheese")
    }
    
    func setupConstraints() {
        if (isUpdatedConstraints == false) {
            isUpdatedConstraints = true
            
            view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
            view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        }
    }

    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.bindSearchImage(query: "cheese")
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
            GPLogger.log(self.viewModel.gpImages.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.viewModel.count) results out of \(self.viewModel.totalCount)"
            }
            self.stopViewAnimation()
        }
    }
}


extension GPSearchViewControllerView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let gpImage = self.viewModel.gpImages[safe : indexPath.row] {
            GPLogger.log(gpImage.title ?? "")
        }
    }
    
}

extension GPSearchViewControllerView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: searchViewControllerViewCellId) as? GPSearchListCell {
            cell.controller = self
            if let gpImage = self.viewModel.gpImages[safe : indexPath.row] {
                cell.gpImage = gpImage
            }
            return cell
        }
        return GPSearchListCell.init(style: .default, reuseIdentifier: searchViewControllerViewCellId)
    }
}



