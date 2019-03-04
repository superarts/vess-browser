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
	}

	func hostListViewModel() -> HostListViewModelProtocol {
		return container.resolve(HostListViewModelProtocol.self)!
	}

	func pageListViewModel() -> PageListViewModelProtocol {
		return container.resolve(PageListViewModelProtocol.self, argument: RealmHost() as Host)!
	}
}
