//
//  GPSearchViewControllerView.swift
//  GiphyTests
//
//  Created by Tirupati Balan on 14/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation
import XCTest

@testable import Giphy

class GPSearchViewControllerViewTests : XCTestCase {

    var searchViewControllerView : GPSearchViewControllerView!

    override func setUp() {
        super.setUp()
        self.searchViewControllerView = GPSearchViewControllerView(style: .plain)
        XCTAssertNotNil(self.searchViewControllerView.searchController)

        self.searchViewControllerView.loadView()
        self.searchViewControllerView.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
        self.searchViewControllerView = nil
    }
    
}

