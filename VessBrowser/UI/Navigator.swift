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
	func setup(window: UIWindow)
}

/// App navigation handling
// AppXXX means it depends on UIKit
// TODO: mutability
class AppNavigator: AppNavigable, DependencyResolvable {

	static var shared: AppNavigable = AppNavigator()
	var navigationController: MainNavigationController!

	func setup(window: UIWindow) {
		let storyboard = UIStoryboard(name: "Navigator", bundle: nil)
		guard let nav = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
			fatalError("BROWSER failed initializing WebsiteList")
		}

        window.backgroundColor = .white
        window.rootViewController = nav
        window.makeKeyAndVisible()

		navigationController = nav
		//set(root: controller(storyboard: "WebsiteList", identifier: "WebsiteListViewController"))
		set(root: dependencyResolverInstance.websiteListViewControllerInstance())
	}

	private func controller(storyboard: String, identifier: String) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboard, bundle: nil)
		return storyboard.instantiateViewController(withIdentifier: identifier)
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