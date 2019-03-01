import Swinject

// MARK: AppNavigator

protocol AppNavigationDependencyInjectable {
	var dependencyInjector: AppNavigationDependencyInjectorProtocol { get }
}

extension AppNavigationDependencyInjectable {
	var dependencyInjector: AppNavigationDependencyInjectorProtocol {
		return DefaultAppNavigationDependencyInjector()
	}
}

protocol AppNavigationDependencyInjectorProtocol {
	func hostListViewController() -> HostListViewController
	func websiteListViewController(host: Host) -> WebsiteListViewController
	func browserViewController(website: Website) -> BrowserViewController
}

/*
 * Discussion: it's possible to wrap `Swinject` with something like `DependencyInjector.register`,
 * instead of using `Container.register`, which introduces a strong dependency of `Swinject`.
 *
 * At some point, strong dependencies from ANY libraries may be removed as a
 * general pattern; but something like RX would be pretty hard to deal with.
 */

struct DefaultAppNavigationDependencyInjector: AppNavigationDependencyInjectorProtocol {
	
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
		/*
		container.register(BrowserViewModelProtocol.self) { _, host in
			BrowserViewModel(host: host)
		}
		container.register(BrowserViewControllerProtocol.self) { (resolver: Resolver, host: Host) -> BrowserViewControllerProtocol in
			var controller = self.controller(storyboard: "Browser", identifier: "BrowserViewController") as! BrowserViewControllerProtocol
			let viewModel = resolver.resolve(BrowserViewModelProtocol.self, argument: host)!
			controller.viewModel = viewModel
			return controller
		}
		*/
		container.register(BrowserViewControllerProtocol.self) { (resolver: Resolver, website: Website) -> BrowserViewControllerProtocol in
			var controller = self.controller(storyboard: "Browser", identifier: "BrowserViewController") as! BrowserViewControllerProtocol
			controller.address = website.address
			return controller
		}
	}

	// Helper
	private func controller(storyboard: String, identifier: String) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboard, bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier)
	}

	// Resolvers
	func hostListViewController() -> HostListViewController {
		return container.resolve(HostListViewControllerProtocol.self) as! HostListViewController
	}

	func websiteListViewController(host: Host) -> WebsiteListViewController {
		return container.resolve(WebsiteListViewControllerProtocol.self, argument: host) as! WebsiteListViewController
	}

	func browserViewController(website: Website) -> BrowserViewController {
		return container.resolve(BrowserViewControllerProtocol.self, argument: website) as! BrowserViewController
	}
}

// MARK: HostList

protocol HostListDependencyInjectable {
	var dependencyInjector: HostListDependencyInjectorProtocol { get }
}

extension HostListDependencyInjectable {
	var dependencyInjector: HostListDependencyInjectorProtocol {
		return DefaultHostListDependencyInjector()
	}
}

protocol HostListDependencyInjectorProtocol {
	func hostAccessor() -> HostAccessorProtocol
}

struct DefaultHostListDependencyInjector: HostListDependencyInjectorProtocol {

	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostAccessorProtocol.self) { _ in
			HostAccessor()
		}
	}

	// Resolver
	func hostAccessor() -> HostAccessorProtocol {
		return container.resolve(HostAccessorProtocol.self)!
	}
}

// MARK: WebsiteList

protocol WebsiteAccessorDependencyInjectable {
	var websiteAccessorDependencyInjector: WebsiteListDependencyInjectorProtocol { get }
}

extension WebsiteAccessorDependencyInjectable {
	var websiteAccessorDependencyInjector: WebsiteListDependencyInjectorProtocol {
		//return DefaultWebsiteListDependencyInjector()
		return DefaultWebsiteListDependencyInjector.shared
	}
}

protocol WebsiteListDependencyInjectorProtocol {
	static var shared: WebsiteListDependencyInjectorProtocol { get }
	func websiteAccessor() -> WebsiteAccessorProtocol
	func register()
	func testEmpty()
	func testSingle()
}

struct DefaultWebsiteListDependencyInjector: WebsiteListDependencyInjectorProtocol {
	static var shared: WebsiteListDependencyInjectorProtocol = DefaultWebsiteListDependencyInjector()
	private let container = Container()

	init() {
		register()
		//testEmpty()
		//testSingle()
	}

	func register() {
		container.register(WebsiteAccessorProtocol.self) { _ in
			DefaultWebsiteAccessor()
		}
	}

	// Tests
	func testEmpty() {
		container.register(WebsiteAccessorProtocol.self) { _ in
			EmptyWebsiteAccessor()
		}
	}

	func testSingle() {
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
	var dependencyInjector: UnitTestDependencyInjectorProtocol { get }
}

extension UnitTestDependencyInjectable {
	var dependencyInjector: UnitTestDependencyInjectorProtocol {
		return DefaultUnitTestDependencyInjector()
	}
}

protocol UnitTestDependencyInjectorProtocol {
	func websiteListViewModel() -> WebsiteListViewModelProtocol
	//func EmptywebsiteAccessor() -> WebsiteAccessorProtocol
}

struct DefaultUnitTestDependencyInjector: UnitTestDependencyInjectorProtocol {

	private let container = Container()

	init() {
		register()
	}

	private func register() {
		/*
		container.register(WebsiteAccessorProtocol.self) { _ in
			return SingleWebsiteAccessor()
		}.initCompleted { _, _ in
			//completion()
		}
		*/

		container.register(WebsiteListViewModelProtocol.self) { (_, host: Host) -> WebsiteListViewModel in
			let vm = WebsiteListViewModel(host: host)
			//vm.websiteAccessorDependencyInjector.testSingle()
			return vm
		}
	}

	/*
	private func removeAll() {
		container.removeAll()
	}
	*/

	// Resolver
	/*
	func EmptyWebsiteAccessor() -> WebsiteAccessorProtocol {
		return container.resolve(WebsiteAccessorProtocol.self)!
	}
	*/

	func websiteListViewModel() -> WebsiteListViewModelProtocol {
		return container.resolve(WebsiteListViewModelProtocol.self, argument: RealmHost() as Host)!
	}
}

/*
 *
	func registerProductionWebsiteAccessor(_ completion: @escaping () -> Void) {
		sharedDependencyInjector.container.register(WebsiteAccessorProtocol.self) { _ in
			return WebsiteAccessor()
		}.initCompleted { _, _ in
			completion()
		}
	}

	func registerEmptyWebsiteAccessor(_ completion: @escaping () -> Void) {
		sharedDependencyInjector.container.register(WebsiteAccessorProtocol.self) { _ in
			return EmptyWebsiteAccessor()
		}.initCompleted { _, _ in
			completion()
		}
	}
	*/