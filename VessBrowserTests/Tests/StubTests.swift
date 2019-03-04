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
					let accessor = EmptyHostAccessor()
					expect(accessor.visit(host: RealmHost())).toNot(throwError())
				}
				it("has nothing") {
					let accessor = EmptyHostAccessor()
					expect(accessor.all()).to(beEmpty())
				}
			}
			context("EmptyHostDatabaseAccessor") {
				it("can store") {
					let accessor = EmptyHostDatabaseAccessor()
					expect(accessor.store(RealmHost())).toNot(throwError())
				}
				it("returns nothing for filter") {
					let accessor = EmptyHostDatabaseAccessor()
					expect(accessor.first(filter: "*")).to(beNil())
				}
				it("has nothing") {
					let accessor = EmptyHostDatabaseAccessor()
					expect(accessor.all()).to(beEmpty())
				}
				it("has nothing for filter") {
					let accessor = EmptyHostDatabaseAccessor()
					expect(accessor.all(filter: "*")).to(beEmpty())
				}
			}
			context("EmptyPageAccessor") {
				it("can visit") {
					let accessor = EmptyPageAccessor()
					expect(accessor.visit(page: RealmPage())).toNot(throwError())
				}
				it("has nothing") {
					let accessor = EmptyPageAccessor()
					expect(accessor.all()).to(beEmpty())
				}
				it("has nothing for given hostAddress") {
					let accessor = EmptyPageAccessor()
					expect(accessor.pages(hostAddress: "www.google.com")).to(beEmpty())
				}
			}
			context("EmptyPageDatabaseAccessor") {
				it("can store") {
					let accessor = EmptyPageDatabaseAccessor()
					expect(accessor.store(RealmPage())).toNot(throwError())
				}
				it("returns nothing for filter") {
					let accessor = EmptyPageDatabaseAccessor()
					expect(accessor.first(filter: "*")).to(beNil())
				}
				it("has nothing") {
					let accessor = EmptyPageDatabaseAccessor()
					expect(accessor.all()).to(beEmpty())
				}
				it("has nothing for filter") {
					let accessor = EmptyPageDatabaseAccessor()
					expect(accessor.all(filter: "*")).to(beEmpty())
				}
			}
		}

		describe("Single stubs") {
			context("SinglePageAccessor") {
				it("can visit") {
					let accessor = SinglePageAccessor()
					expect(accessor.visit(page: RealmPage())).toNot(throwError())
				}
				it("has 1 Page") {
					let accessor = SinglePageAccessor()
					expect(accessor.all()).to(haveCount(1))
				}
				it("has 1 Page for any given hostAddress") {
					let accessor = SinglePageAccessor()
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
