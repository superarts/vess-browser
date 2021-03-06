//
//  VessBrowserTests.swift
//  VessBrowserTests
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Quick
import Nimble
import RealmSwift
@testable import VessBrowser

class HostAccessorTests: QuickSpec, HostAccessible, HostCreatable {
	override func spec() {
		context("HostAccessor") {
			it("is empty if database is empty") {
				let accessor: HostAccessorProtocol = self.sharedHostAccessorDependencyInjector.hostAccessor()
				accessor.sharedHostDatabaseAccessorDependencyInjector.registerEmpty()
				expect(accessor.visit(host: self.hostCreator.empty)).toNot(throwError())
				expect(accessor.all()).to(beEmpty())
			}
		}
	}
}

class PageAccessorTests: QuickSpec, PageAccessible, HostCreatable, PageCreatable {
	override func spec() {
		context("PageAccessor") {
			it("is empty if database is empty") {
				let accessor: PageAccessorProtocol = self.sharedPageAccessorDependencyInjector.pageAccessor()
				accessor.sharedPageDatabaseAccessorDependencyInjector.registerEmpty()
				expect(accessor.visit(page: self.pageCreator.empty)).toNot(throwError())
				expect(accessor.all()).to(beEmpty())
				expect(accessor.pages(host: self.hostCreator.empty)).to(beEmpty())
				expect(accessor.pages(host: self.hostCreator.blank)).to(beEmpty())
				expect(accessor.pages(host: self.hostCreator.google)).to(beEmpty())
			}
		}
	}
}

class ViewModelTests: QuickSpec, TestViewModelDependencyInjectable {
	override func spec() {
		describe("HostList") {
			context("HostListViewModel") {
				it("is empty if it's not reloaded") {
					let viewModel: HostListViewModelProtocol = self.sharedTestViewModelDependencyInjector.hostListViewModel()
					viewModel.sharedHostAccessorDependencyInjector.registerEmpty()
					expect(viewModel.hosts.value).to(beEmpty())
				}
				it("is not empty if no hosts loaded, as default host(s) will be used") {
					let viewModel: HostListViewModelProtocol = self.sharedTestViewModelDependencyInjector.hostListViewModel()
					viewModel.sharedHostAccessorDependencyInjector.registerEmpty()
					viewModel.reload()
					expect(viewModel.hosts.value).toNot(beEmpty())
				}
			}
		}
		describe("PageList") {
			context("PageListViewModel") {
				it("should have a valid searchPage") {
					let viewModel: PageListViewModelProtocol = self.sharedTestViewModelDependencyInjector.pageListViewModel()
					expect(viewModel.searchPage).toNot(beNil())
					expect(viewModel.searchPage.address).toNot(beEmpty())
				}
				it("is empty if it's not reloaded") {
					let viewModel: PageListViewModelProtocol = self.sharedTestViewModelDependencyInjector.pageListViewModel()
					viewModel.sharedPageAccessorDependencyInjector.registerEmpty()
					expect(viewModel.pages.value).to(beEmpty())
				}
				it("is not empty if no pages loaded, as default pages will be used") {
					let viewModel: PageListViewModelProtocol = self.sharedTestViewModelDependencyInjector.pageListViewModel()
					viewModel.sharedPageAccessorDependencyInjector.registerEmpty()
					viewModel.reload()
					expect(viewModel.pages.value).toNot(beEmpty())
				}
				it("has 1 page if a single page is loaded") {
					let viewModel: PageListViewModelProtocol = self.sharedTestViewModelDependencyInjector.pageListViewModel()
					viewModel.sharedPageAccessorDependencyInjector.registerSingle()
					viewModel.reload()
					expect(viewModel.pages.value).to(haveCount(1))
				}
			}
		}
		describe("Browser") {
			context("BrowserViewModel") {
				it("should have a Page after initialized") {
					let viewModel: BrowserViewModelProtocol = self.sharedTestViewModelDependencyInjector.browserViewModel()
					expect(viewModel.page).toNot(beNil())
				}
			}
		}
	}
}

class DatabaseTests: QuickSpec, HostCreatable, PageCreatable {
	override func spec() {
		super.spec()

		beforeSuite {
			Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "TestDatabase"
		}

		beforeEach {
    		let realm = try! Realm()
			try! realm.write {
				realm.deleteAll()
			}
		}

		describe("Host") {
			context("HostDatabaseAccessor") {
				it("can store and retrieve 1 item") {
        			let host = self.hostCreator.empty
					let accessor: HostDatabaseAccessorProtocol = RealmHostDatabaseAccessor()
					expect(accessor.store(host: host)).toNot(throwError())
					expect(accessor.all()).to(haveCount(1))
					expect(accessor.first(filter: "address == 'https://www.bing.com'")).to(beNil())
					expect(accessor.first(filter: "address == '\(host.address)'")).toNot(beNil())
					expect(accessor.all(filter: "address == 'https://www.bing.com'")).to(beEmpty())
					expect(accessor.all(filter: "address == '\(host.address)'")).to(haveCount(1))
				}
			}
		}

		describe("Page") {
			context("PageDatabaseAccessor") {
				it("can store and retrieve 1 item") {
        			let page = self.pageCreator.google
					let accessor: PageDatabaseAccessorProtocol = RealmPageDatabaseAccessor()
					expect(accessor.store(page: page)).toNot(throwError())
					expect(accessor.all()).to(haveCount(1))
					expect(accessor.first(filter: "address == 'https://www.bing.com'")).to(beNil())
					expect(accessor.first(filter: "address == '\(page.address)'")).toNot(beNil())
					expect(accessor.all(filter: "address == 'https://www.bing.com'")).to(beEmpty())
					expect(accessor.all(filter: "address == '\(page.address)'")).to(haveCount(1))
				}
			}
		}
	}
}
