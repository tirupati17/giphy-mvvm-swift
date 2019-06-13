//  
//  GPSearchViewControllerView.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import UIKit

let searchViewControllerViewCellId = "GPSearchViewControllerViewCellId"

class GPSearchViewControllerView: GPTableViewController {
    private var viewModel = GPSearchViewControllerViewModel()
    override func loadView() {
        super.loadView()
        self.prepareTableView()
    }
    
    /// Prepare the table view.
    private func prepareTableView() {
        tableView.register(GPSearchListCell.self, forCellReuseIdentifier: searchViewControllerViewCellId)
        tableView.refreshControl = self.refreshControl
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeViewModel()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {

    }
    
    // Observe event from view-model
    fileprivate func observeViewModel() {
        
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

        self.viewModel.serverErrorStatus = { error in
            self.showAlertWithTitleAndMessage(message: error.localizedDescription)
        }
        
        self.viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.navigationItem.title = "\(String(describing: self?.viewModel.viewModelCount)) results out of \(String(describing: self?.viewModel.totalCount))"
            }
            self?.stopViewAnimation()
        }
    }
}

extension GPSearchViewControllerView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, let didGetData = self.viewModel.didGetData {
            didGetData(text, false)
        }
    }
}

extension GPSearchViewControllerView {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewModelAtIndex = self.viewModel.viewModelAtIndex {
            if let gpImage = viewModelAtIndex(indexPath) {
                GPLogger.log(gpImage.title ?? "")
                self.viewModel.imageSelected(gpImage)
            }
        }
    }
    
}

extension GPSearchViewControllerView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.viewModelCount
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: searchViewControllerViewCellId) as? GPSearchListCell {
            cell.controller = self
            if let viewModelAtIndex = self.viewModel.viewModelAtIndex {
                if let gpImage = viewModelAtIndex(indexPath) {
                    cell.gpImage = gpImage
                }
            }
            return cell
        }
        return GPSearchListCell.init(style: .default, reuseIdentifier: searchViewControllerViewCellId)
    }
}



