//  
//  GPSearchViewControllerView.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import UIKit
import Social

let searchViewControllerViewCellId = "GPSearchViewControllerViewCellId"

class GPSearchViewControllerView: GPViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var collectionView : UICollectionView!
    var isUpdatedConstraints: Bool? = false

    var searchText : String? {
        didSet {
            if let text = self.searchText {
                self.viewModel.didGetData(text, false) //false means lazy loading disable
            }
        }
    }
    
    private var viewModel = GPSearchViewControllerViewModel()
    override func loadView() {
        super.loadView()
        self.prepareCollectionView()
    }
    
    /// Prepare the table view.
    private func prepareCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: (self.view.frame.size.width/2) - 10, height: 200)

        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .black
        collectionView.register(GPSearchListCell.self, forCellWithReuseIdentifier: searchViewControllerViewCellId)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        if (isUpdatedConstraints == false) {
            isUpdatedConstraints = true
            
            view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
            view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.textColor = UIColor.white
        
        self.navigationItem.titleView = searchController.searchBar
        self.observeViewModel()
        
        self.searchText = "" //load trending gif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        if let text = self.searchText {
            self.searchText = text
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // Observe event from view-model
    fileprivate func observeViewModel() {
        
        self.viewModel.showActivityView = { [weak self] (items) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityVc.popoverPresentationController?.sourceView = strongSelf.view
                strongSelf.present(activityVc, animated: true, completion: nil)
            }
        }
        
        self.viewModel.showAlertClosure = {
            if let alert = self.viewModel.alertMessage {
                self.showAlertWithTitleAndMessage(message: alert)
            }
        }
        
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async {
                if self.viewModel.isLoading {
                    UIApplication.showNetworkActivity()
                    self.startViewAnimation()
                } else {
                    self.refreshControl.endRefreshing()
                    UIApplication.hideNetworkActivity()
                    self.stopViewAnimation()
                }
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
                strongSelf.collectionView.reloadData()
            }
        }
    }
}

extension GPSearchViewControllerView : UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {[weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
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

extension GPSearchViewControllerView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.viewModelCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchViewControllerViewCellId, for: indexPath) as! GPSearchListCell
        
        cell.controller = self
        if let viewModelAtIndex = self.viewModel.viewModelAtIndex {
            if let gpImage = viewModelAtIndex(indexPath) {
                cell.gpImage = gpImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.viewModel.viewModelCount == (indexPath.row + 1) {
            if self.viewModel.viewModelCount < self.viewModel.totalCount {
                if let text = self.searchText {
                    self.viewModel.didGetData(text, true) //true means lazy loading enable
                }
            }
        }
    }

}

extension GPSearchViewControllerView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let viewModelAtIndex = self.viewModel.viewModelAtIndex {
            if let gpImage = viewModelAtIndex(indexPath) {
                GPLogger.log(gpImage.title ?? "")
                self.viewModel.imageSelected(gpImage)
            }
        }
    }

}


