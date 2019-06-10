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
    var selectedObject: GPImage?
    var gpImages: [GPImage] = [GPImage]()

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var didGetData: (() -> ())?

    init(withGPSearchViewController serviceProtocol: GPSearchViewControllerServiceProtocol = GPSearchViewControllerService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- bind search image
    func bindSearchImage(query : String) {
        switch networkStatus {
            case .offline:
                self.isDisconnected = true
                self.internetConnectionStatus?()
            case .online:
                self.service.searchImage(query, limit: self.searchLimit, offset: self.searchOffset, success: { (model) in
                    self.model = model
                    self.didGetData?()
                }) { (error) in
                    self.serverErrorStatus?()
                }
                break
            default:
                break
        }
    }

}

extension GPSearchViewControllerViewModel {

}
