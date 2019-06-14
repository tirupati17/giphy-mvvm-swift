//
//  GPSearchViewControllerViewModelTests.swift
//  GiphyTests
//
//  Created by Tirupati Balan on 14/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation
import XCTest

@testable import Giphy

class GPSearchViewControllerViewModelTests : XCTestCase {
    
    var searchViewControllerViewModel : GPSearchViewControllerViewModel!
    var mockGPSearchViewControllerService : MockGPSearchViewControllerService!
    
    override func setUp() {
        super.setUp()
        
        self.searchViewControllerViewModel = GPSearchViewControllerViewModel(withGPSearchViewController: MockGPSearchViewControllerService())
        //Call didGetData which will use MockGPSearchViewControllerService protocol to return data
        self.searchViewControllerViewModel.didGetData("cheese", false) //without lazy loading
        
        self.mockGPSearchViewControllerService = MockGPSearchViewControllerService()
        XCTAssertNotNil(self.mockGPSearchViewControllerService.searchViewControllerModel)
    }
    
    override func tearDown() {
        super.tearDown()
        
        self.searchViewControllerViewModel = nil
        self.mockGPSearchViewControllerService = nil
    }
    
    func testSearchViewControllerViewModelObserveClosure() {
        XCTAssertNotNil(self.searchViewControllerViewModel.reloadTable)
        XCTAssertNotNil(self.searchViewControllerViewModel.viewDidLoad)
        XCTAssertNotNil(self.searchViewControllerViewModel.imageSelected)
        XCTAssertNotNil(self.searchViewControllerViewModel.viewModelAtIndex)
    }
    
    func testSearchViewControllerViewModelDataSource() {
        let model = self.mockGPSearchViewControllerModel()
        if let gpImages = model.gpImages {
            XCTAssertEqual(self.searchViewControllerViewModel.viewModelCount, gpImages.count)
        } else {
            XCTFail("gpImages of mockGPSearchViewControllerModel should not be nil")
        }
        XCTAssertEqual(self.searchViewControllerViewModel.numberOfSection, 1)
        XCTAssertEqual(self.searchViewControllerViewModel.rowHeight, 206)
        if let pagination = model.pagination {
            XCTAssertEqual(self.searchViewControllerViewModel.totalCount, pagination.totalCount)
            XCTAssertEqual(self.searchViewControllerViewModel.offset, pagination.offset)
        } else {
            XCTFail("pagination of mockGPSearchViewControllerModel should not be nil")
        }
    }
    
    func mockGPSearchViewControllerModel() -> GPSearchViewControllerModel {
        return self.mockGPSearchViewControllerService.searchViewControllerModel
    }
}
