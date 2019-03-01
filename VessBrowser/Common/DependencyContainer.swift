import Swinject

/*
/// Register

protocol DependencyRegistrable {
	var dependencyRegisterInstance: DependencyRegister { get }
}

extension DependencyRegistrable {
	var dependencyRegisterInstance: DependencyRegister {
		return DependencyRegister()
	}
}

struct DependencyRegister: DependencyInjectable, DependencyResolvable {

	private func controller(storyboard: String, identifier: String) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboard, bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier)
	}

	func removeAll() {
		sharedDependencyInjector.container.removeAll()
	}

	func registerAppNavigator() {
		sharedDependencyInjector.container.register(AppNavigable.self) { _ in
			AppNavigator.shared
		}
		sharedDependencyInjector.container.register(HostListViewController.self) { _ in
			self.controller(storyboard: "HostList", identifier: "HostListViewController") as! HostListViewController
		}
		sharedDependencyInjector.container.register(WebsiteListViewController.self) { _ in
			self.controller(storyboard: "WebsiteList", identifier: "WebsiteListViewController") as! WebsiteListViewController
		}
	}

	func registerHostList() {
		sharedDependencyInjector.container.register(HostListViewModelProtocol.self) { _ in
			HostListViewModel()
		}
		sharedDependencyInjector.container.register(HostAccessorProtocol.self) { _ in
			HostAccessor()
		}
	}

	func registerWebsiteList(host: Host) {
		sharedDependencyInjector.container.register(WebsiteListViewModelProtocol.self) { _ in
			WebsiteListViewModel(host: host)
		}
		sharedDependencyInjector.container.register(WebsiteAccessorProtocol.self) { _ in
			WebsiteAccessor()
		}
	}

	/*
	func registerWebsiteList(host: Host) {
		sharedDependencyInjector.container.register(WebsiteListViewModelProtocol.self) { _ in
			WebsiteListViewModel(host: host)
		}
		sharedDependencyInjector.container.register(WebsiteAccessorProtocol.self) { _ in
			WebsiteAccessor()
		}
	}
	*/

	// Shouldn't register production dependencies; testing only
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
}

/// Resolver

protocol DependencyResolvable {
	var dependencyResolverInstance: DependencyResolver { get }
}

extension DependencyResolvable {
	var dependencyResolverInstance: DependencyResolver {
		return DependencyResolver()
	}
}

/// Navigator dependency
struct DependencyResolver: DependencyInjectable {

	func sharedAppNavigator() -> AppNavigable {
		return sharedDependencyInjector.container.resolve(AppNavigable.self)!
	}

	func hostListViewControllerInstance() -> HostListViewController {
		return sharedDependencyInjector.container.resolve(HostListViewController.self)!
	}

	func hostListViewModelInstance() -> HostListViewModelProtocol {
		return sharedDependencyInjector.container.resolve(HostListViewModelProtocol.self)!
	}

	func websiteListViewControllerInstance() -> WebsiteListViewController {
		return sharedDependencyInjector.container.resolve(WebsiteListViewController.self)!
	}

	func websiteListViewModelInstance() -> WebsiteListViewModelProtocol {
		return sharedDependencyInjector.container.resolve(WebsiteListViewModelProtocol.self)!
	}
}

/// HostList dependency
extension DependencyResolver {

	func hostAccessorInstance() -> HostAccessorProtocol {
		return sharedDependencyInjector.container.resolve(HostAccessorProtocol.self)!
	}
}

/// WebsiteList dependency
extension DependencyResolver {

	func websiteAccessorInstance() -> WebsiteAccessorProtocol {
		return sharedDependencyInjector.container.resolve(WebsiteAccessorProtocol.self)!
	}
}

/// Swinject
protocol DependencyInjectable {
	var sharedDependencyInjector: DependencyInjector { get }
}

extension DependencyInjectable {
	var sharedDependencyInjector: DependencyInjector {
		return DependencyInjector.shared
	}
}

struct DependencyInjector {
	static let shared = DependencyInjector()
	let container = Container()
}
*/

////////////////////////

protocol AppNavigationDependencyInjectable {
	var dependencyInjector: AppNavigationDependencyInjectorProtocol { get }
}

extension AppNavigationDependencyInjectable {
	var dependencyInjector: AppNavigationDependencyInjectorProtocol {
		return AppNavigationDependencyInjector()
	}
}

protocol AppNavigationDependencyInjectorProtocol {
	func hostListViewController() -> HostListViewController
	func websiteListViewController(host: Host) -> WebsiteListViewController
	func browserViewController(website: Website) -> BrowserViewController
}

struct AppNavigationDependencyInjector: AppNavigationDependencyInjectorProtocol {
	
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

///

protocol HostListDependencyInjectable {
	var dependencyInjector: HostListDependencyInjectorProtocol { get }
}

extension HostListDependencyInjectable {
	var dependencyInjector: HostListDependencyInjectorProtocol {
		return HostListDependencyInjector()
	}
}

protocol HostListDependencyInjectorProtocol {
	func hostAccessor() -> HostAccessorProtocol
}

struct HostListDependencyInjector: HostListDependencyInjectorProtocol {

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

///

protocol WebsiteListDependencyInjectable {
	var dependencyInjector: WebsiteListDependencyInjectorProtocol { get }
}

extension WebsiteListDependencyInjectable {
	var dependencyInjector: WebsiteListDependencyInjectorProtocol {
		return WebsiteListDependencyInjector()
	}
}

protocol WebsiteListDependencyInjectorProtocol {
	func websiteAccessor() -> WebsiteAccessorProtocol
}

struct WebsiteListDependencyInjector: WebsiteListDependencyInjectorProtocol {

	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(WebsiteAccessorProtocol.self) { _ in
			WebsiteAccessor()
		}
	}

	// Resolver
	func websiteAccessor() -> WebsiteAccessorProtocol {
		return container.resolve(WebsiteAccessorProtocol.self)!
	}
}