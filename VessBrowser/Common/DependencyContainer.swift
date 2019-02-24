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
		sharedDependencyInjector.container.register(WebsiteListViewController.self) { _ in
			self.controller(storyboard: "WebsiteList", identifier: "WebsiteListViewController") as! WebsiteListViewController
		}
	}

	func registerWebsiteList() {
		sharedDependencyInjector.container.register(WebsiteListViewModelProtocol.self) { _ in
			WebsiteListViewModel()
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

struct DependencyResolver: DependencyInjectable {

	func sharedAppNavigator() -> AppNavigable {
		return sharedDependencyInjector.container.resolve(AppNavigable.self)!
	}

	func websiteListViewControllerInstance() -> WebsiteListViewController {
		return sharedDependencyInjector.container.resolve(WebsiteListViewController.self)!
	}

	func websiteListViewModelInstance() -> WebsiteListViewModelProtocol {
		return sharedDependencyInjector.container.resolve(WebsiteListViewModelProtocol.self)!
	}

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