import UIKit

/// Use sharedNavigator to handle navigation
protocol Navigatable: DependencyResolvable {
	var sharedNavigator: AppNavigable { get }
}

extension Navigatable {
	var sharedNavigator: AppNavigable {
		return dependencyResolverInstance.sharedAppNavigator()
	}
}

protocol AppNavigable {
	static var shared: AppNavigable { get }
	// TODO: delete me
	var navigationController: MainNavigationController! { get }

	func setupNavigation(window: UIWindow)
	func setRootAsHostList()
	//func setRootAsWebsiteList()
	func pushWebsiteList(host: Host)
	func popToRoot()
}

/// App navigation handling
// AppXXX means it depends on UIKit
// TODO: mutability, single responsibility
class AppNavigator: AppNavigable, DependencyRegistrable, DependencyResolvable {

	static var shared: AppNavigable = AppNavigator()
	var navigationController: MainNavigationController!

	func setupNavigation(window: UIWindow) {
		let storyboard = UIStoryboard(name: "Navigator", bundle: nil)
		guard let nav = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
			fatalError("BROWSER failed initializing WebsiteList")
		}

        window.backgroundColor = .white
        window.rootViewController = nav
        window.makeKeyAndVisible()

		navigationController = nav
	}

	func setRootAsHostList() {
		dependencyRegisterInstance.registerHostList()
		let hostListViewController = dependencyResolverInstance.hostListViewControllerInstance()
		hostListViewController.viewModel = dependencyResolverInstance.hostListViewModelInstance()
		set(root: hostListViewController)
	}

	/*
	func setRootAsWebsiteList() {
		dependencyRegisterInstance.registerWebsiteList(host: Host())
		let websiteListViewController = dependencyResolverInstance.websiteListViewControllerInstance()
		websiteListViewController.viewModel = dependencyResolverInstance.websiteListViewModelInstance()
		set(root: websiteListViewController)
	}
	*/

	func pushWebsiteList(host: Host) {
		dependencyRegisterInstance.registerWebsiteList(host: host)
		let websiteListViewController = dependencyResolverInstance.websiteListViewControllerInstance()
		websiteListViewController.viewModel = dependencyResolverInstance.websiteListViewModelInstance()
		navigationController.pushViewController(websiteListViewController, animated: true)
	}

	func popToRoot() {
		navigationController.popToRootViewController(animated: true)
	}

	private func set(root: UIViewController) {
		navigationController.viewControllers = [root]
	}
}

class MainNavigationController: UINavigationController {
}