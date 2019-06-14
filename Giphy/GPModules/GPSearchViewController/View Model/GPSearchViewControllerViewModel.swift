//  
//  GPSearchViewControllerViewModel.swift
//  Giphy
//
//  Created by Tirupati Balan on 06/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

class GPSearchViewControllerViewModel {

    private let service: GPSearchViewControllerServiceProtocol

    private var gpImages: [GPImage] = [GPImage]()
    private var model: GPSearchViewControllerModel? {
        didSet {
            if let model = self.model {
                if let gpImages = model.gpImages {
                    if self.isLazyLoading == true {
                        self.gpImages.append(contentsOf: gpImages)
                    } else {
                        self.gpImages = gpImages
                    }
                }
            }
        }
    }

    ///MARK: -- Model Datasource
    var viewModelCount: Int {
        return self.gpImages.count
    }
    
    var totalCount: Int {
        if let pagination = self.model?.pagination {
            if let totalCount = pagination.totalCount {
                return totalCount
            }
        }
        return 0
    }
    
    var offset: Int {
        if let pagination = self.model?.pagination {
            if let offset = pagination.offset {
                return offset
            }
        }
        return 0
    }
    
    var rowHeight: CGFloat {
        return 206
    }
    
    var numberOfSection: Int = 1

    ///MARK: -- Pagination
    private var searchLimit: String = "5"
    private var isLazyLoading: Bool = false
    private var searchOffset: String {
        return "\(self.viewModelCount)"
    }

    //MARK: -- Network checking

    /// Define networkStatus for check network connection
    var networkStatus = Reach().connectionStatus()

    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }

    //MARK: -- UI Status

    /// Update the loading status, use HUD or Activity Indicator UI
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    // MARK: closure observe by view (Should not be nil after view initialization)
    var reloadTable: ()->() = {}
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: ((Error) -> ())?
    var showActivityView: ([Any])->() = { _ in }

    // MARK: closure observe by view-model (Should not be nil after view-model initialization)
    var viewDidLoad: ()->() = {}
    var didGetData: ((_ query : String, _ isLazyLoading : Bool) -> ()) = {_,_ in }
    var imageSelected: ((GPImage)-> ()) = { _ in }
    var viewModelAtIndex: ((IndexPath)-> GPImage?)?
    
    init(withGPSearchViewController serviceProtocol: GPSearchViewControllerServiceProtocol = GPSearchViewControllerService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        self.observeView()
    }
    
    private func observeView() {
        viewDidLoad = { [weak self] in
            //perform any initial operation from view-model(Here)
            self?.reloadTable()
        }
        
        // seach image based on query
        didGetData = { query, isLazyLoading in
            self.isLazyLoading = isLazyLoading
            self.isLoading = true
            self.bindSearchImage(query: query, completion: { [weak self] in
                self?.isLoading = false
                self?.reloadTable()
            })
        }
        
        //navigate to detail page or perform some action via view
        imageSelected = { gpImage in
            DispatchQueue.global(qos: .userInteractive).async {
                var items: [Any] = []
                if let images = gpImage.images {
                    if let downsizedMedium = images.downsizedMedium {
                        if let shareUrl = downsizedMedium.url {
                            if let url = URL(string: shareUrl) {
                                items.append(NSData(contentsOf: url) as Any)
                                self.showActivityView(items)
                            }
                        }
                    }
                }
            }
        }
        
        viewModelAtIndex = { indexPath in
            return self.gpImages[safe : indexPath.row]
        }
    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- search image
    private func bindSearchImage(query : String, completion: @escaping ()->()) {
        switch networkStatus {
            case .offline:
                self.isDisconnected = true
                self.internetConnectionStatus?()
            case .online:
                if query.isEmpty { //load trending gif
                    self.service.trendingImage(self.searchLimit, offset: self.searchOffset, success: { (model) in
                        self.model = model
                        completion()
                    }) { (error) in
                        self.serverErrorStatus?(error)
                    }
                } else {
                    self.service.searchImage(query, limit: self.searchLimit, offset: self.searchOffset, success: { (model) in
                        self.model = model
                        completion()
                    }) { (error) in
                        self.serverErrorStatus?(error)
                    }
                }
                break
            default:
                break
        }
    }

}

extension GPSearchViewControllerViewModel {

}
