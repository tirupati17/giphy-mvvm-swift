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

    private var model: GPSearchViewControllerModel? {
        didSet {
            if let model = self.model {
                if let gpImages = model.gpImages {
                    self.gpImages.append(contentsOf: gpImages)
                    self.count = self.gpImages.count
                }
                if let pagination = model.pagination {
                    if let totalCount = pagination.totalCount {
                        self.totalCount = totalCount
                    }
                    if let offset = pagination.offset {
                        self.offset = offset
                    }
                }
            }
        }
    }

    /// Count your data in model
    var count: Int = 0
    var totalCount: Int = 0
    var offset: Int = 0
    var rowHeight: CGFloat = 64
    var numberOfSection: Int = 1

    /// for pagination
    var searchLimit: String = "10"
    var searchOffset: String {
        return "\(self.count)"
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

    /// Define selected model
    var gpImages: [GPImage] = [GPImage]()

    /// Callback to reload the table.
    var reloadTable: ()->() = { }
    
    // MARK: Input
    var viewDidLoad: ()->() = {}
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: ((Error) -> ())?
    var didGetData: ((_ query:String) -> ())?
    
    // MARK: Events
    
    /// Callback to pass the selected image.
    var imageSelected: (GPImage)->() = { _ in }
    
    // MARK: Output
    var numberOfRows = 0

    init(withGPSearchViewController serviceProtocol: GPSearchViewControllerServiceProtocol = GPSearchViewControllerService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        viewDidLoad = { [weak self] in
            //perform any initial operation from view-model(Here)
            self?.reloadTable()
        }
        
        // seach image based on query
        didGetData = { query in
            self.bindSearchImage(query: query, completion: { [weak self] in
                self?.reloadTable()
            })
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
                self.service.searchImage(query, limit: self.searchLimit, offset: self.searchOffset, success: { (model) in
                    self.model = model
                    completion()
                }) { (error) in
                    self.serverErrorStatus?(error)
                }
                break
            default:
                break
        }
    }

}

extension GPSearchViewControllerViewModel {

}
