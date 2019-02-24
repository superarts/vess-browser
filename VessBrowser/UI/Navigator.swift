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
	var navigationController: MainNavigationController! { get }

	func setupNavigation(window: UIWindow)
	func setRootAsWebsiteList()
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

	func setRootAsWebsiteList() {
		dependencyRegisterInstance.registerWebsiteList()
		let websiteListViewController = dependencyResolverInstance.websiteListViewControllerInstance()
		websiteListViewController.viewModel = dependencyResolverInstance.websiteListViewModelInstance()
		set(root: websiteListViewController)
	}

	private func set(root: UIViewController) {
		navigationController.viewControllers = [root]
	}
}

class MainNavigationController: UINavigationController {
}

/// 

protocol WebsiteManagable {
	//var sharedNavigator: Navigator { get }
}

extension WebsiteManagable {
	/*
	var sharedNavigator: Navigator { 
		return Navigator.shared 
	}
	*/
}

/// Recording website
struct WebsiteRecorder {
	func visit(website: RealmWebsite) {
		
	}
}