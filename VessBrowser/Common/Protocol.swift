//
//  Protocol.swift
//  VessBrowser
//
//  Created by Leo on 3/3/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import UIKit

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

/// Stateless

/**
* Discussion: there are some limitations regarding this implementation, so it is removed from the project.
* We are making a convention that all non-shared instances *SHOULD* be stateless.
*/

/*
/// Stateless components do *NOT* have properties and non-static functions.
/// It also should *NOT* contain static properties.
class StatelessObject {
init() {
fatalError("\(self) should be Stateless: no properties and/or non-static functions allowed")
}

/// Try YourStatelessClass.test()
func test() {
print("Stateless test: never reach here")
}
}
*/
