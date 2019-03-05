//
//  TestManager.swift
//  VessBrowserTests
//
//  Created by Leo on 3/3/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Foundation

// MARK: - HostAccessor

struct EmptyHostAccessor: HostAccessorProtocol {
	func visit(host: Host) { }
	func all() -> [Host] { return [] }
}

// MARK: - PageAccessor

struct EmptyPageAccessor: PageAccessorProtocol {
	func visit(page: Page) { }
	func all() -> [Page] { return [] }
	func pages(hostAddress: String) -> [Page] { return [] }
}

struct SinglePageAccessor: PageAccessorProtocol {
	func visit(page: Page) { }
	func all() -> [Page] { return [RealmPage()] }
	func pages(hostAddress: String) -> [Page] { return [RealmPage()] }
}

/// Mark: - HostDatabaseAccessor

struct EmptyHostDatabaseAccessor: HostDatabaseAccessorProtocol {

	func store(_ host: Host) { }
	func update(host: Host, transaction: VoidClosure?) { }
	func first(filter: String) -> Host? { return nil }
	func all() -> [Host] { return [] }
	func all(filter: String) -> [Host] { return [] }
}

/// Mark: - PageDatabaseAccessor

struct EmptyPageDatabaseAccessor: PageDatabaseAccessorProtocol {

	func store(_ page: Page) { }
	func update(page: Page, transaction: VoidClosure?) { }
	func first(filter: String) -> Page? { return nil }
	func all() -> [Page] { return [] }
	func all(filter: String) -> [Page] { return [] }
}
