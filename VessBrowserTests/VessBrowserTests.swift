//
//  VessBrowserTests.swift
//  VessBrowserTests
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import XCTest
@testable import VessBrowser

class WebsiteListViewModelTests: XCTestCase, UnitTestDependencyInjectable {

	// TODO: remove this test
	/*
	func testWebsiteListViewModelProtocol() {
		dependencyRegisterInstance.registerProductionWebsiteAccessor {
			let viewModel: WebsiteListViewModelProtocol = self.dependencyResolverInstance.websiteListViewModelInstance()
			viewModel.setup()
			viewModel.reload()
			XCTAssert(!viewModel.websites.value.isEmpty)
		}
	}
    */

	func testWebsiteListViewModelProtocolEmpty() {
		let viewModel: WebsiteListViewModelProtocol = dependencyInjector.websiteListViewModel()
		viewModel.websiteAccessorDependencyInjector.testEmpty()
		viewModel.setup()
		viewModel.reload()
		//XCTAssert(viewModel.websites.value.isEmpty)
		XCTAssertEqual(viewModel.websites.value.count, 4)
	}

	func testWebsiteListViewModelProtocolSingle() {
		let viewModel: WebsiteListViewModelProtocol = dependencyInjector.websiteListViewModel()
		viewModel.websiteAccessorDependencyInjector.testSingle()
		viewModel.setup()
		viewModel.reload()
		XCTAssertEqual(viewModel.websites.value.count, 1)
	}

	/*
	func testWebsiteListViewModelProtocolEmpty2() {
		dependencyRegisterInstance.registerEmptyWebsiteAccessor {
    		let viewModel: WebsiteListViewModelProtocol = self.dependencyResolverInstance.websiteListViewModelInstance()
    		viewModel.setup()
    		viewModel.reload()
    		XCTAssert(viewModel.websites.value.isEmpty)
		}
	}
	*/
}
