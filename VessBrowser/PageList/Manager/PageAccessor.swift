import Foundation

/// Access web pages

protocol PageAccessible: PageAccessorDependencyInjectable {
	var pageAccessor: PageAccessorProtocol { get }
}

extension PageAccessible {
	var pageAccessor: PageAccessorProtocol {
		return sharedPageAccessorDependencyInjector.pageAccessor()
	}
}

protocol PageAccessorProtocol: PageDatabaseAccessible {
	func visit(page: Page)
	func all() -> [Page]
	func pages(hostAddress: String) -> [Page]
}

struct DefaultPageAccessor: PageAccessorProtocol {

	func visit(page: Page) {
		if pageDatabaseAccessor.first(filter: "address == \"\(page.address)\"") == nil {
			pageDatabaseAccessor.store(page)
		}
	}

	func all() -> [Page] {
		let pages = pageDatabaseAccessor.all()
		return pages.reversed()
	}

	func pages(hostAddress: String) -> [Page] {
		let pages = pageDatabaseAccessor.all(filter: "host == \"\(hostAddress)\"")
		return pages.reversed()
	}
}
