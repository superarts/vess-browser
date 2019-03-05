import UIKit
import SCLAlertView

/// AppNavigator should be owned by app entry point, which is AppDelegate in iOS
protocol AppNavigable: AppNavigatorDependencyInjectable {
	var sharedAppNavigator: AppNavigatorProtocol { get }
}

extension AppNavigable {
	var sharedAppNavigator: AppNavigatorProtocol {
		return sharedAppNavigatorDependencyInjector.sharedAppNavigator()
	}
}

protocol AppNavigatorProtocol {

	func setupNavigation(window: UIWindow)
	func setRootAsHostList()
}

/// App navigation handling
// AppXXX means it depends on UIKit
// TODO: mutability, single responsibility
class DefaultAppNavigator: AppNavigatorProtocol, AppNavigatorDependencyInjectable {

	static var shared: AppNavigatorProtocol = DefaultAppNavigator()
	private var navigationController: MainNavigationController!

	func setupNavigation(window: UIWindow) {
		let storyboard = UIStoryboard(name: "Navigator", bundle: nil)
		guard let nav = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController else {
			fatalError("BROWSER failed initializing PageList")
		}

        window.backgroundColor = .white
        window.rootViewController = nav
        window.makeKeyAndVisible()

		navigationController = nav
	}

	func setRootAsHostList() {
		var hostListViewController = sharedAppNavigatorDependencyInjector.hostListViewController()
		hostListViewController.handleSelectHost = { [unowned self] host in
			self.pushPageList(host: host)
		}
		hostListViewController.handleSearch = { [unowned self] in
			let page = RealmPage()
			page.address = "https://www.google.com"
			self.pushBrowser(page: page)
		}
		set(root: hostListViewController)
	}

	private func pushPageList(host: Host) {
		var pageListViewController = sharedAppNavigatorDependencyInjector.pageListViewController(host: host)
		pageListViewController.handleSelectPage = { [unowned self] page in
			self.pushBrowser(page: page)
		}
		pageListViewController.handleSearchPage = { [unowned self] page in
			self.pushBrowser(page: page)
		}
		navigationController.pushViewController(pageListViewController.viewController, animated: true)
	}

	private func pushBrowser(page: Page) {
		var browserViewController = sharedAppNavigatorDependencyInjector.browserViewController(page: page)
		browserViewController.handleHome = { [unowned self] in
			self.navigationController.popToRootViewController(animated: true)
		}
		browserViewController.handleManualEntry = { [unowned self] in
			self.showAlert { text in
				print("NAVIGATOR browser visit: \(text)")
				browserViewController.visit(address: text)
			}
		}
		navigationController.pushViewController(browserViewController.viewController, animated: true)
	}

	private func set(root: ViewControllerConvertable) {
		navigationController.viewControllers = [root.viewController]
	}

	private func showAlert(completion: @escaping StringClosure) {
		let alert = SCLAlertView()
		let txt = alert.addTextField("URL Address")
		alert.addButton("Go") {
			completion(txt.text ?? "")
		}
		alert.showEdit("Visit Page", subTitle: "Enter URL Address", closeButtonTitle: "Cancel")
	}
}

// MARK: - AppTestable

/*
Discussion: AppTestable is a workaround to improve test coverage.
Proper UI tests should be used to address this issue.
*/
extension DefaultAppNavigator: AppTestable {
	func testApp() {
		pushPageList(host: RealmHost())
		pushBrowser(page: RealmPage())
		showAlert { _ in }
	}
}

// MARK: - MainNavigationController

class MainNavigationController: UINavigationController {
}
