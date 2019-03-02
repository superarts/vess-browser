import UIKit

/// Use sharedNavigator to handle navigation
protocol AppNavigatable {
	var sharedAppNavigator: AppNavigable { get }
}

extension AppNavigatable {
	var sharedAppNavigator: AppNavigable {
		return AppNavigator.shared
	}
}

protocol AppNavigable {
	static var shared: AppNavigable { get }
	// TODO: delete me
	//var navigationController: MainNavigationController! { get }

	func setupNavigation(window: UIWindow)
	func setRootAsHostList()
	//func setRootAsWebsiteList()
	func pushWebsiteList(host: Host)
	func pushBrowser(website: Website)
	func popToRoot()
}

/// App navigation handling
// AppXXX means it depends on UIKit
// TODO: mutability, single responsibility
class AppNavigator: AppNavigable, AppNavigatorDependencyInjectable {

	static var shared: AppNavigable = AppNavigator()
	private var navigationController: MainNavigationController!

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
		let hostListViewController = appNavigatorDependencyInjector.hostListViewController()
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
		let websiteListViewController = appNavigatorDependencyInjector.websiteListViewController(host: host)
		navigationController.pushViewController(websiteListViewController, animated: true)
	}

	func pushBrowser(website: Website) {
		let browserViewController = appNavigatorDependencyInjector.browserViewController(website: website)
		navigationController.pushViewController(browserViewController, animated: true)
	}

	/*
	func pushBrowser(website: Website) {
		let storyboard = UIStoryboard(name: "Browser", bundle: nil)
		guard let controller = storyboard.instantiateViewController(withIdentifier: "BrowserViewController") as? BrowserViewController else {
			fatalError("Browser failed")
		}
		controller.address = website.address
		self.sharedNavigator.navigationController.pushViewController(controller, animated: true)
	}
	*/

	func popToRoot() {
		navigationController.popToRootViewController(animated: true)
	}

	private func set(root: UIViewController) {
		navigationController.viewControllers = [root]
	}
}

class MainNavigationController: UINavigationController {
}
