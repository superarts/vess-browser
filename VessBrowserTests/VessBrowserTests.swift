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
			viewModel.reload()
			XCTAssert(!viewModel.websites.value.isEmpty)
		}
	}

	func testWebsiteListViewModelProtocolEmpty() {
		dependencyRegisterInstance.removeAll()
		dependencyRegisterInstance.registerEmptyWebsiteAccessor {
    		let viewModel: WebsiteListViewModelProtocol = self.dependencyResolverInstance.websiteListViewModelInstance()
    		viewModel.setup()
    		viewModel.reload()
    		XCTAssert(viewModel.websites.value.isEmpty)
		}
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