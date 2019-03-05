//
//  TestViewModelDependencyInjector.swift
//  VessBrowserTests
//
//  Created by Leo on 3/3/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Swinject
@testable import VessBrowser

// MARK: - Dependency injector for ViewModels

/*
	Discussion: In our MVVM-Navigator model, ViewModels are injected in AppNavigator level.
	AppNavigator owns ViewControllers directly, so ViewModels are not exposed.
	This DependencyInjector is created to handle ViewModels dependency injection.
*/

protocol TestViewModelDependencyInjectable {
	var sharedTestViewModelDependencyInjector: TestViewModelDependencyInjectorProtocol { get }
}

extension TestViewModelDependencyInjectable {
	var sharedTestViewModelDependencyInjector: TestViewModelDependencyInjectorProtocol {
		return DefaultTestViewModelDependencyInjector.shared
	}
}

protocol TestViewModelDependencyInjectorProtocol {

	func hostListViewModel() -> HostListViewModelProtocol
	func pageListViewModel() -> PageListViewModelProtocol
	func browserViewModel() -> BrowserViewModelProtocol
}

struct DefaultTestViewModelDependencyInjector: TestViewModelDependencyInjectorProtocol {

	static let shared: TestViewModelDependencyInjectorProtocol = DefaultTestViewModelDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostListViewModelProtocol.self) { _ in
			return HostListViewModel()
		}
		container.register(PageListViewModelProtocol.self) { (_, host: Host) -> PageListViewModel in
			return PageListViewModel(host: host)
		}
		container.register(BrowserViewModelProtocol.self) { (_, page: Page) -> BrowserViewModel in
			return BrowserViewModel(page: page)
		}
	}

	func hostListViewModel() -> HostListViewModelProtocol {
		return container.resolve(HostListViewModelProtocol.self)!
	}

	func pageListViewModel() -> PageListViewModelProtocol {
		return container.resolve(PageListViewModelProtocol.self, argument: RealmHost() as Host)!
	}

	func browserViewModel() -> BrowserViewModelProtocol {
		return container.resolve(BrowserViewModelProtocol.self, argument: RealmPage() as Page)!
	}
}

// MARK: - TestModelProvider

protocol TestModelProvidable {
	var testModelProvider: TestModelProviderProtocol { get }
}

extension TestModelProvidable {
	var testModelProvider: TestModelProviderProtocol {
		return TestModelProvider()
	}
}

protocol TestModelProviderProtocol {
	var GoogleHost: Host { get }
	var GooglePage: Page { get }
}

struct TestModelProvider: TestModelProviderProtocol {
	var GoogleHost: Host {
		let host = RealmHost()
		host.address = "https://www.google.com"
		return host
	}
	var GooglePage: Page {
		let page = RealmPage()
		page.address = "https://www.google.com"
		return page
	}
}
