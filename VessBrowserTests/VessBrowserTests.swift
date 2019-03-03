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

class PageListViewModelTests: QuickSpec, UnitTestDependencyInjectable {
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
		}
		describe("PageList") {
			context("PageListViewModel") {
				it("is empty if it's not reloaded") {
					let viewModel: PageListViewModelProtocol = self.unitTestDependencyInjector.pageListViewModel()
					viewModel.sharedPageAccessorDependencyInjector.registerEmpty()
					expect(viewModel.pages.value).to(beEmpty())
				}
				it("is not empty if no pages loaded, as default pages will be used") {
					let viewModel: PageListViewModelProtocol = self.unitTestDependencyInjector.pageListViewModel()
					viewModel.sharedPageAccessorDependencyInjector.registerEmpty()
					viewModel.reload()
					expect(viewModel.pages.value).toNot(beEmpty())
				}
				it("has 1 page if a single page is loaded") {
					let viewModel: PageListViewModelProtocol = self.unitTestDependencyInjector.pageListViewModel()
					viewModel.sharedPageAccessorDependencyInjector.registerSingle()
					viewModel.reload()
					expect(viewModel.pages.value).to(haveCount(1))
				}
			}
		}
	}
}
