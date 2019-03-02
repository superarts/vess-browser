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

	func testWebsiteListViewModelProtocolEmpty() {
		let viewModel: WebsiteListViewModelProtocol = unitTestDependencyInjector.websiteListViewModel()
		viewModel.sharedWebsiteAccessorDependencyInjector.registerEmpty()
		viewModel.reload()
		XCTAssert(viewModel.websites.value.isEmpty)
	}

	func testWebsiteListViewModelProtocolSingle() {
		let viewModel: WebsiteListViewModelProtocol = unitTestDependencyInjector.websiteListViewModel()
		viewModel.sharedWebsiteAccessorDependencyInjector.registerSingle()
		viewModel.setup()
		viewModel.reload()
		XCTAssertEqual(viewModel.websites.value.count, 1)
	}
}