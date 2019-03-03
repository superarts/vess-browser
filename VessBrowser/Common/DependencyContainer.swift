import Swinject

// MARK: AppNavigator

/**
 * Discussion: When a component confirms to Protocol `AppNavigatable`, it would have 2 things:
 *
 * - `sharedAppNavigator` to handle navigation; "shared" means it's a shared instance, instead of a transient object
 * - `appNavigatorDependencyInjector` to handle additional dependency injection (test only)
 */

protocol AppNavigatorDependencyInjectable {
	var appNavigatorDependencyInjector: AppNavigatorDependencyInjectorProtocol { get }
}

extension AppNavigatorDependencyInjectable {
	var appNavigatorDependencyInjector: AppNavigatorDependencyInjectorProtocol {
		return DefaultAppNavigatorDependencyInjector.shared
	}
}

/**
 * Discussion: it's possible to use a "global" DependencyInjector to inject other DIs via protocol,
 * but the advantage of doing so is yet to be seen.
 */

protocol AppNavigatorDependencyInjectorProtocol {

	func hostListViewController() -> HostListViewControllerProtocol
	func websiteListViewController(host: Host) -> WebsiteListViewControllerProtocol
	func browserViewController(website: Website) -> BrowserViewController
}

/**
 * Discussion: it's possible to wrap `Swinject` with something like `DependencyInjector.register`,
 * instead of using `Container.register`, which introduces a strong dependency of `Swinject`.
 *
 * At some point, strong dependencies from ANY libraries may be removed as a
 * general pattern; but something like RX would be pretty hard to deal with.
 */

struct DefaultAppNavigatorDependencyInjector: AppNavigatorDependencyInjectorProtocol {

	static let shared: AppNavigatorDependencyInjectorProtocol = DefaultAppNavigatorDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(AppNavigable.self) { _ in
			AppNavigator.shared
		}

		// HostList
		container.register(HostListViewModelProtocol.self) { _ in
			HostListViewModel()
		}
		container.register(HostListViewControllerProtocol.self) { resolver in
			var controller = self.controller(storyboard: "HostList", identifier: "HostListViewController") as! HostListViewControllerProtocol
			let viewModel = resolver.resolve(HostListViewModelProtocol.self)!
			controller.viewModel = viewModel
			return controller
		}

		// WebsiteList: owns a Host
		container.register(WebsiteListViewModelProtocol.self) { _, host in
			WebsiteListViewModel(host: host)
		}
		container.register(WebsiteListViewControllerProtocol.self) { (resolver: Resolver, host: Host) -> WebsiteListViewControllerProtocol in
			var controller = self.controller(storyboard: "WebsiteList", identifier: "WebsiteListViewController") as! WebsiteListViewControllerProtocol
			let viewModel = resolver.resolve(WebsiteListViewModelProtocol.self, argument: host)!
			controller.viewModel = viewModel
			return controller
		}

		// Browser: owns a Website
		container.register(BrowserViewModelProtocol.self) { _, website in
			BrowserViewModel(website: website)
		}
		container.register(BrowserViewControllerProtocol.self) { (resolver: Resolver, website: Website) -> BrowserViewControllerProtocol in
			var controller = self.controller(storyboard: "Browser", identifier: "BrowserViewController") as! BrowserViewControllerProtocol
			let viewModel = resolver.resolve(BrowserViewModelProtocol.self, argument: website)!
			controller.viewModel = viewModel
			return controller
		}
	}

	// Helper
	private func controller(storyboard: String, identifier: String) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboard, bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier)
	}

	// Resolvers
	func hostListViewController() -> HostListViewControllerProtocol {
		return container.resolve(HostListViewControllerProtocol.self)!
	}

	func websiteListViewController(host: Host) -> WebsiteListViewControllerProtocol {
		return container.resolve(WebsiteListViewControllerProtocol.self, argument: host)!
	}

	func browserViewController(website: Website) -> BrowserViewController {
		return container.resolve(BrowserViewControllerProtocol.self, argument: website) as! BrowserViewController
	}
}

// MARK: HostList

protocol HostAccessorDependencyInjectable {
	var sharedHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol { get }
}

extension HostAccessorDependencyInjectable {
	var sharedHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol {
		return DefaultHostAccessorDependencyInjector.shared
	}
}

protocol HostAccessorDependencyInjectorProtocol {

	func hostAccessor() -> HostAccessorProtocol
	func registerEmpty()
}

struct DefaultHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol {

	static var shared: HostAccessorDependencyInjectorProtocol = DefaultHostAccessorDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostAccessorProtocol.self) { _ in
			DefaultHostAccessor()
		}
	}

	func registerEmpty() {
		container.register(HostAccessorProtocol.self) { _ in
			EmptyHostAccessor()
		}
	}

	// Resolver
	func hostAccessor() -> HostAccessorProtocol {
		return container.resolve(HostAccessorProtocol.self)!
	}
}

///

protocol HostDatabaseAccessorDependencyInjectable {
	var sharedHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol { get }
}

extension HostDatabaseAccessorDependencyInjectable {
	var sharedHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol {
		return DefaultHostDatabaseAccessorDependencyInjector.shared
	}
}

protocol HostDatabaseAccessorDependencyInjectorProtocol {

	func hostDatabaseAccessor() -> RealmDatabaseAccessor<RealmHost>
	//func registerEmpty()
}

struct DefaultHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol {

	static var shared: HostDatabaseAccessorDependencyInjectorProtocol = DefaultHostDatabaseAccessorDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(RealmDatabaseAccessor<RealmHost>.self) { _ in
			RealmDatabaseAccessor<RealmHost>()
		}
	}

	/*
	func registerEmpty() {
		container.register(HostAccessorProtocol.self) { _ in
			EmptyHostAccessor()
		}
	}
	*/

	// Resolver
	func hostDatabaseAccessor() -> RealmDatabaseAccessor<RealmHost> {
		return container.resolve(RealmDatabaseAccessor<RealmHost>.self)!
	}
}
// MARK: WebsiteAccessor

protocol WebsiteAccessorDependencyInjectable {
	var sharedWebsiteAccessorDependencyInjector: WebsiteListDependencyInjectorProtocol { get }
}

extension WebsiteAccessorDependencyInjectable {
	var sharedWebsiteAccessorDependencyInjector: WebsiteListDependencyInjectorProtocol {
		return DefaultWebsiteListDependencyInjector.shared
	}
}

protocol WebsiteListDependencyInjectorProtocol {

	func websiteAccessor() -> WebsiteAccessorProtocol
	func register()
	func registerEmpty()
	func registerSingle()
}

struct DefaultWebsiteListDependencyInjector: WebsiteListDependencyInjectorProtocol {

	static var shared: WebsiteListDependencyInjectorProtocol = DefaultWebsiteListDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	func register() {
		container.register(WebsiteAccessorProtocol.self) { _ in
			DefaultWebsiteAccessor()
		}
	}

	// Tests
	func registerEmpty() {
		container.register(WebsiteAccessorProtocol.self) { _ in
			EmptyWebsiteAccessor()
		}
	}

	func registerSingle() {
		container.register(WebsiteAccessorProtocol.self) { _ in
			SingleWebsiteAccessor()
		}
	}

	// Resolver
	func websiteAccessor() -> WebsiteAccessorProtocol {
		return container.resolve(WebsiteAccessorProtocol.self)!
	}
}

// MARK: UnitTest

protocol UnitTestDependencyInjectable {
	var unitTestDependencyInjector: UnitTestDependencyInjectorProtocol { get }
}

extension UnitTestDependencyInjectable {
	var unitTestDependencyInjector: UnitTestDependencyInjectorProtocol {
		return DefaultUnitTestDependencyInjector()
	}
}

protocol UnitTestDependencyInjectorProtocol {

	func hostListViewModel() -> HostListViewModelProtocol
	func websiteListViewModel() -> WebsiteListViewModelProtocol
}

struct DefaultUnitTestDependencyInjector: UnitTestDependencyInjectorProtocol {

	static let shared: UnitTestDependencyInjectorProtocol = DefaultUnitTestDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostListViewModelProtocol.self) { _ in
			return HostListViewModel()
		}
		container.register(WebsiteListViewModelProtocol.self) { (_, host: Host) -> WebsiteListViewModel in
			return WebsiteListViewModel(host: host)
		}
	}

	func hostListViewModel() -> HostListViewModelProtocol {
		return container.resolve(HostListViewModelProtocol.self)!
	}

	func websiteListViewModel() -> WebsiteListViewModelProtocol {
		return container.resolve(WebsiteListViewModelProtocol.self, argument: RealmHost() as Host)!
	}
}