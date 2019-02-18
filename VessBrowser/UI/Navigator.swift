import UIKit

struct Navigator {

	static var shared = Navigator()
	var navigationController: MainNavigationController!

	mutating func setup(window: UIWindow) {
		let storyboard = UIStoryboard(name: "Navigator", bundle: nil)
		guard let nav = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
			fatalError("BROWSER failed initializing WebsiteList")
		}

        window.backgroundColor = .white
        window.rootViewController = nav
        window.makeKeyAndVisible()

		navigationController = nav
		set(root: controller(storyboard: "WebsiteList", identifier: "WebsiteListViewController"))
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