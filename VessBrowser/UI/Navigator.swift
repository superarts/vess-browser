import UIKit

/// AppNavigator should be owned by app entry point, which is AppDelegate in iOS
protocol AppNavigatable {
	var sharedAppNavigator: AppNavigable { get }
}

extension AppNavigatable {
	var sharedAppNavigator: AppNavigable {
		return AppNavigator.shared
	}
}

protocol AppNavigable {

	func setupNavigation(window: UIWindow)
	func setRootAsHostList()
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
		var hostListViewController = appNavigatorDependencyInjector.hostListViewController()
		hostListViewController.handleSelectHost = { [unowned self] host in
			self.pushWebsiteList(host: host)
		}
		hostListViewController.handleSearch = { [unowned self] in
			let website = RealmWebsite()
			website.address = "https://www.google.com"
			self.pushBrowser(website: website)
		}
		set(root: hostListViewController)
	}

	private func pushWebsiteList(host: Host) {
		var websiteListViewController = appNavigatorDependencyInjector.websiteListViewController(host: host)
		websiteListViewController.handleSelectWebsite = { [unowned self] website in
			self.pushBrowser(website: website)
		}
		websiteListViewController.handleSearchWebsite = { [unowned self] website in
			self.pushBrowser(website: website)
		}
		navigationController.pushViewController(websiteListViewController.viewController, animated: true)
	}

	private func pushBrowser(website: Website) {
		let browserViewController = appNavigatorDependencyInjector.browserViewController(website: website)
		browserViewController.handleHome = { [unowned self] in
			self.navigationController.popToRootViewController(animated: true)
		}
		navigationController.pushViewController(browserViewController, animated: true)
	}

	private func set(root: ViewControllerConvertable) {
		navigationController.viewControllers = [root.viewController]
	}
}

class MainNavigationController: UINavigationController {
}