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
		describe("HostList") {
			context("HostListViewModel") {
				it("is empty if it's not reloaded") {
					let viewModel: HostListViewModelProtocol = self.unitTestDependencyInjector.hostListViewModel()
					viewModel.sharedHostAccessorDependencyInjector.registerEmpty()
					expect(viewModel.hosts.value).to(beEmpty())
				}
				it("is not empty if no hosts loaded, as default host(s) will be used") {
					let viewModel: HostListViewModelProtocol = self.unitTestDependencyInjector.hostListViewModel()
					viewModel.sharedHostAccessorDependencyInjector.registerEmpty()
					viewModel.reload()
					expect(viewModel.hosts.value).toNot(beEmpty())
				}
			}
			context("HostAccessor") {
				it("is empty if if no hosts loaded from database") {
					let hostAccessor: HostAccessorProtocol = self.unitTestDependencyInjector.hostAccessor()
					hostAccessor.sharedHostDatabaseAccessorDependencyInjector.registerEmpty()
					expect(hostAccessor.all()).to(beEmpty())
				}
			}
		}
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