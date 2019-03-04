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
	func pageListViewController(host: Host) -> PageListViewControllerProtocol
	func browserViewController(page: Page) -> BrowserViewController
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

		// PageList: owns a Host
		container.register(PageListViewModelProtocol.self) { _, host in
			PageListViewModel(host: host)
		}
		container.register(PageListViewControllerProtocol.self) { (resolver: Resolver, host: Host) -> PageListViewControllerProtocol in
			var controller = self.controller(storyboard: "PageList", identifier: "PageListViewController") as! PageListViewControllerProtocol
			let viewModel = resolver.resolve(PageListViewModelProtocol.self, argument: host)!
			controller.viewModel = viewModel
			return controller
		}

		// Browser: owns a Page
		container.register(BrowserViewModelProtocol.self) { _, page in
			BrowserViewModel(page: page)
		}
		container.register(BrowserViewControllerProtocol.self) { (resolver: Resolver, page: Page) -> BrowserViewControllerProtocol in
			var controller = self.controller(storyboard: "Browser", identifier: "BrowserViewController") as! BrowserViewControllerProtocol
			let viewModel = resolver.resolve(BrowserViewModelProtocol.self, argument: page)!
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

	func pageListViewController(host: Host) -> PageListViewControllerProtocol {
		return container.resolve(PageListViewControllerProtocol.self, argument: host)!
	}

	func browserViewController(page: Page) -> BrowserViewController {
		return container.resolve(BrowserViewControllerProtocol.self, argument: page) as! BrowserViewController
	}
}
