import UIKit

typealias VoidClosure = () -> Void
typealias HostClosure = (Host) -> Void
typealias WebsiteClosure = (Website) -> Void

///

protocol ViewControllerConvertable {
	var viewController: UIViewController { get }
}

extension ViewControllerConvertable where Self: UIViewController {
	var viewController: UIViewController {
		return self
	}
}

///

protocol LifeCycleManagable {

	/// When view is loaded - viewDidLoad
	/// Discussion: do we need it if we are using RxSwift?
	//func setup()

	/// When view is refreshed - viewWillAppear
	func reload()
}

extension LifeCycleManagable {

	/*
	func setup() {
		print("LIFECYCLE skipping setup")
	}
	*/

	func reload() {
		print("LIFECYCLE skipping reload")
	}
}