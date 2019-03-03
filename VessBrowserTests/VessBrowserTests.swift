//
//  VessBrowserTests.swift
//  VessBrowserTests
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Quick
import Nimble
@testable import VessBrowser

class WebsiteListViewModelTests: QuickSpec, UnitTestDependencyInjectable {
	override func spec() {
		describe("WebsiteList") {
			context("WebsiteListViewModel") {
				it("is empty if it's not reloaded") {
					let viewModel: WebsiteListViewModelProtocol = self.unitTestDependencyInjector.websiteListViewModel()
					viewModel.sharedWebsiteAccessorDependencyInjector.registerEmpty()
					expect(viewModel.websites.value).to(beEmpty())
				}
				it("is not empty if no websites loaded, as default websites will be used") {
					let viewModel: WebsiteListViewModelProtocol = self.unitTestDependencyInjector.websiteListViewModel()
					viewModel.sharedWebsiteAccessorDependencyInjector.registerEmpty()
					viewModel.reload()
					expect(viewModel.websites.value).toNot(beEmpty())
				}
				it("has 1 website if a single website is loaded") {
					let viewModel: WebsiteListViewModelProtocol = self.unitTestDependencyInjector.websiteListViewModel()
					viewModel.sharedWebsiteAccessorDependencyInjector.registerSingle()
					viewModel.reload()
					expect(viewModel.websites.value).to(haveCount(1))
				}
			}
		}
	}
}