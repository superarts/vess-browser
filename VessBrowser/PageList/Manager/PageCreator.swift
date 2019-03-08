import Foundation

/// Protocol: PageCreatable
/// Interface: PageCreatorProtocol
/// Default implementation: DefaultPageCreator
/// Dependency injector protocol: PageCreatorDependencyInjectable
/// Shared dependency injector: sharedPageCreatorDependencyInjector

// MARK: Protocol

protocol PageCreatable: PageCreatorDependencyInjectable {
	var pageCreator: PageCreatorProtocol { get }
}

extension PageCreatable {
	var pageCreator: PageCreatorProtocol {
		return sharedPageCreatorDependencyInjector.pageCreator()
	}
}

// MARK: - Interface

protocol PageCreatorProtocol: HostDatabaseAccessible {
	var empty: Page { get }
	var blank: Page { get }
	var google: Page { get }
	var bing: Page { get }
	var yahoo: Page { get }
	var baidu: Page { get }
	func page(address: String) -> Page
	func page(name: String, address: String) -> Page
	func page(name: String, address: String, host: String) -> Page
}

// MARK: - Implementation

struct DefaultPageCreator: PageCreatorProtocol {
	var empty: Page {
		return RealmPage()
	}

	var blank: Page {
		let page = RealmPage()
		page.name = "Search"
		page.address = "blank"
		return page
	}

	var google: Page {
		let page = RealmPage()
		page.name = "Google"
		page.address = "https://www.google.com/"
		page.host = "blank"
		return page
	}

	var bing: Page {
		let page = RealmPage()
		page.name = "Bing"
		page.address = "https://www.bing.com/"
		page.host = "blank"
		return page
	}

	var yahoo: Page {
		let page = RealmPage()
		page.name = "Yahoo"
		page.address = "https://www.yahoo.com/"
		page.host = "blank"
		return page
	}

	var baidu: Page {
		let page = RealmPage()
		page.name = "百度"
		page.address = "https://www.baidu.com/"
		page.host = "blank"
		return page
	}

	func page(address: String) -> Page {
		let page = RealmPage()
		page.name = address // TODO: default page name?
		page.address = address
		return page
	}

	func page(name: String, address: String) -> Page {
		let page = RealmPage()
		page.name = name
		page.address = address
		return page
	}

	func page(name: String, address: String, host: String) -> Page {
		let page = RealmPage()
		page.name = name
		page.address = address
		page.host = host
		return page
	}
}
