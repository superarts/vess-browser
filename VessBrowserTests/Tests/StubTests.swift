//
//  StubTests.swift
//  VessBrowserTests
//
//  Created by Leo on 3/3/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Quick
import Nimble
@testable import VessBrowser

class StubTests: QuickSpec {
	override func spec() {
		describe("Empty stubs") {
			context("EmptyHostAccessor") {
				it("can visit") {
					let accessor: HostAccessorProtocol = EmptyHostAccessor()
					expect(accessor.visit(host: RealmHost())).toNot(throwError())
				}
				it("has nothing") {
					let accessor: HostAccessorProtocol = EmptyHostAccessor()
					expect(accessor.all()).to(beEmpty())
				}
			}
			context("EmptyHostDatabaseAccessor") {
				it("can store") {
					let accessor: HostDatabaseAccessorProtocol = EmptyHostDatabaseAccessor()
					expect(accessor.store(host: RealmHost())).toNot(throwError())
				}
				it("returns nothing for filter") {
					let accessor: HostDatabaseAccessorProtocol = EmptyHostDatabaseAccessor()
					expect(accessor.first(filter: "*")).to(beNil())
				}
				it("has nothing") {
					let accessor: HostDatabaseAccessorProtocol = EmptyHostDatabaseAccessor()
					expect(accessor.all()).to(beEmpty())
				}
				it("has nothing for filter") {
					let accessor: HostDatabaseAccessorProtocol = EmptyHostDatabaseAccessor()
					expect(accessor.all(filter: "*")).to(beEmpty())
				}
			}
			context("EmptyPageAccessor") {
				it("can visit") {
					let accessor: PageAccessorProtocol = EmptyPageAccessor()
					expect(accessor.visit(page: RealmPage())).toNot(throwError())
				}
				it("has nothing") {
					let accessor: PageAccessorProtocol = EmptyPageAccessor()
					expect(accessor.all()).to(beEmpty())
				}
				it("has nothing for given hostAddress") {
					let accessor: PageAccessorProtocol = EmptyPageAccessor()
					expect(accessor.pages(hostAddress: "www.google.com")).to(beEmpty())
				}
			}
			context("EmptyPageDatabaseAccessor") {
				it("can store") {
					let accessor: PageDatabaseAccessorProtocol = EmptyPageDatabaseAccessor()
					expect(accessor.store(page: RealmPage())).toNot(throwError())
				}
				it("returns nothing for filter") {
					let accessor: PageDatabaseAccessorProtocol = EmptyPageDatabaseAccessor()
					expect(accessor.first(filter: "*")).to(beNil())
				}
				it("has nothing") {
					let accessor: PageDatabaseAccessorProtocol = EmptyPageDatabaseAccessor()
					expect(accessor.all()).to(beEmpty())
				}
				it("has nothing for filter") {
					let accessor: PageDatabaseAccessorProtocol = EmptyPageDatabaseAccessor()
					expect(accessor.all(filter: "*")).to(beEmpty())
				}
			}
		}

		describe("Single stubs") {
			context("SinglePageAccessor") {
				it("can visit") {
					let accessor: PageAccessorProtocol = SinglePageAccessor()
					expect(accessor.visit(page: RealmPage())).toNot(throwError())
				}
				it("has 1 Page") {
					let accessor: PageAccessorProtocol = SinglePageAccessor()
					expect(accessor.all()).to(haveCount(1))
				}
				it("has 1 Page for any given hostAddress") {
					let accessor: PageAccessorProtocol = SinglePageAccessor()
					expect(accessor.pages(hostAddress: "www.google.com")).to(haveCount(1))
				}
			}
		}
	}
}

class ProtocolExtensionTests: QuickSpec,
	LifeCycleManagable,
	EmptyRegistrable, SingleRegistrable
{
	override func spec() {
		describe("Life cycle") {
			context("LifeCycleManagable") {
				it("can reload") {
					expect(self.reload()).toNot(throwError())
				}
			}
		}
		describe("Registrable") {
			context("EmptyRegistrable") {
				it("can registerEmpty") {
					expect(self.registerEmpty()).toNot(throwError())
				}
			}
			context("SingleRegistrable") {
				it("can registerSingle") {
					expect(self.registerSingle()).toNot(throwError())
				}
			}
		}
	}
}
