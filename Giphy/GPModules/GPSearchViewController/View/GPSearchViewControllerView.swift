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
    let searchController = UISearchController(searchResultsController: nil)
    var searchText : String = "" {
        didSet {
            self.viewModel.didGetData(searchText, false)
        }
    }
    
    private var viewModel = GPSearchViewControllerViewModel()
    override func loadView() {
        super.loadView()
        self.prepareTableView()
    }
    
    /// Prepare the table view.
    private func prepareTableView() {
        tableView.backgroundColor = .black
        tableView.register(GPSearchListCell.self, forCellReuseIdentifier: searchViewControllerViewCellId)
        tableView.refreshControl = self.refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self //Disable it for search press based result
        //searchController.searchResultsUpdater = self //Enable it for quick result
        searchController.dimsBackgroundDuringPresentation = false
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.separatorColor = UIColor.clear

        self.navigationItem.title = "GIPHY"

        self.observeViewModel()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel.didGetData(searchText, false)
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
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return } //as self is weak so chances are it can be nil
                strongSelf.tableView.reloadData()
                if strongSelf.viewModel.viewModelCount > 0 && strongSelf.viewModel.totalCount > 0 {
                    strongSelf.navigationItem.title = "\(String(describing: strongSelf.viewModel.viewModelCount)) results out of \(String(describing: strongSelf.viewModel.totalCount))"
                } else {
                    strongSelf.navigationItem.title = "Giphy"
                }
            }
        }
    }
}

extension GPSearchViewControllerView : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            self.searchText = text
            self.searchController.dismiss(animated: true, completion: nil)
        }
    }
}

extension GPSearchViewControllerView : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.searchText = text
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.viewModelCount == (indexPath.row + 1) {
            if self.viewModel.viewModelCount < self.viewModel.totalCount {
                self.viewModel.didGetData(self.searchText, true) //load more images
            }
        }
    }

}



