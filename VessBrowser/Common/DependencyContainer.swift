import Swinject

/// Register

protocol DependencyRegistrable {
	var dependencyRegisterInstance: DependencyRegister { get }
}

extension DependencyRegistrable {
	var dependencyRegisterInstance: DependencyRegister {
		return DependencyRegister()
	}
}

struct DependencyRegister: DependencyInjectable {

	private func controller(storyboard: String, identifier: String) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboard, bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier)
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
