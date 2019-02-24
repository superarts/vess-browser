//
//  VessBrowserTests.swift
//  VessBrowserTests
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import XCTest
@testable import VessBrowser

class VessBrowserTests: XCTestCase, DependencyRegistrable, DependencyResolvable {

	// TODO: remove this test
	func testWebsiteListViewModelProtocol() {
		dependencyRegisterInstance.registerProductionWebsiteAccessor {
			let viewModel: WebsiteListViewModelProtocol = self.dependencyResolverInstance.websiteListViewModelInstance()
			viewModel.setup()
			viewModel.load()
			XCTAssert(!viewModel.websites.value.isEmpty)
		}
	}

	func testWebsiteListViewModelProtocolEmpty() {
		dependencyRegisterInstance.registerEmptyWebsiteAccessor {
    		let viewModel: WebsiteListViewModelProtocol = self.dependencyResolverInstance.websiteListViewModelInstance()
    		viewModel.setup()
    		viewModel.load()
    		XCTAssert(viewModel.websites.value.isEmpty)
		}
	}

	/*
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	*/
}
