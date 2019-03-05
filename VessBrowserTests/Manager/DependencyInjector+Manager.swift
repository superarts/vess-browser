//
//  DependencyInjector+Registable.swift
//  VessBrowserTests
//
//  Created by Leo on 3/3/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Foundation

/**
 * Discussion: ideally these would be put inside Test target,
 * but it is not achievable: https://gist.github.com/superarts/3b081043df427c69d1331ddad6d20135
 *
 * Unfortunately, for the same reason, EmptyDataManagers have to be put inside App target.
 */

/// Test private IBOutlets and IBActions
protocol AppTestable {
	func testApp()
}

/// Register Empty Dependency
protocol EmptyRegistrable {
	func registerEmpty()
}

extension EmptyRegistrable {
	func registerEmpty() { }
}

/// Register dependency that provides only 1 result
protocol SingleRegistrable {
	func registerSingle()
}

extension SingleRegistrable {
	func registerSingle() { }
}

// MARK: - Dependency injector for HostAccessor

extension DefaultHostAccessorDependencyInjector {

	func registerEmpty() {
		container.register(HostAccessorProtocol.self) { _ in
			EmptyHostAccessor()
		}
	}
}

// MARK: - Dependency injector for PageAccessor

extension DefaultPageListDependencyInjector {

	func registerEmpty() {
		container.register(PageAccessorProtocol.self) { _ in
			EmptyPageAccessor()
		}
	}

	func registerSingle() {
		container.register(PageAccessorProtocol.self) { _ in
			SinglePageAccessor()
		}
	}
}

// MARK: - Dependency injector for HostDatabaseAccessor

extension DefaultHostDatabaseAccessorDependencyInjector {

	func registerEmpty() {
		container.register(HostDatabaseAccessorProtocol.self) { _ in
			EmptyHostDatabaseAccessor()
		}
	}
}

// MARK: - Dependency injector for PageDatabaseAccessor

extension DefaultPageDatabaseAccessorDependencyInjector {

	func registerEmpty() {
		container.register(PageDatabaseAccessorProtocol.self) { _ in
			EmptyPageDatabaseAccessor()
		}
	}
}
