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

    private var viewModel = GPSearchViewControllerViewModel()
    override func loadView() {
        super.loadView()
        self.prepareTableView()
        self.setupConstraints()
    }
    
    /// Prepare the table view.
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GPSearchListCell.self, forCellReuseIdentifier: searchViewControllerViewCellId)
        
        tableView.sectionIndexColor = .darkGray
        tableView.sectionIndexBackgroundColor = .clear
        tableView.refreshControl = self.refreshControl
        
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observeEvents()
        self.viewModel.didGetData!("cheese")
    }
    
    func setupConstraints() {
        if (isUpdatedConstraints == false) {
            isUpdatedConstraints = true
            
            view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
            view.addConstraintsWithFormat("V:|[v0]|", views: tableView)
        }
    }

    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.didGetData!("cheese")
    }
    
    // Observe event from view-model
    fileprivate func observeEvents() {
        
        self.viewModel.showAlertClosure = {
            if let alert = self.viewModel.alertMessage {
                self.showAlertWithTitleAndMessage(message: alert)
            }
        }
        
        self.viewModel.imageSelected = { gpImage in
            DispatchQueue.main.async {
                GPLogger.log(gpImage.title ?? "")
                //navigate to detail page
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

        self.viewModel.serverErrorStatus = { error in
            self.showAlertWithTitleAndMessage(message: error.localizedDescription)
        }
        
        self.viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.navigationItem.title = "\(String(describing: self?.viewModel.count)) results out of \(String(describing: self?.viewModel.totalCount))"
            }
            self?.stopViewAnimation()
        }
    }
}


extension GPSearchViewControllerView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let gpImage = self.viewModel.gpImages[safe : indexPath.row] {
            GPLogger.log(gpImage.title ?? "")
            self.viewModel.imageSelected(gpImage)
        }
    }
    
}

extension GPSearchViewControllerView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
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



