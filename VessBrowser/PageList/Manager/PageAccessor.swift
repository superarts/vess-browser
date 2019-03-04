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

protocol PageAccessorProtocol {
	func visit(page: Page)
	func all() -> [Page]
	func pages(hostAddress: String) -> [Page]
}

struct DefaultPageAccessor: PageAccessorProtocol, PageDatabaseAccessible {

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

/// Test target

struct EmptyPageAccessor: PageAccessorProtocol {
	func visit(page: Page) { }
	func all() -> [Page] { return [] }
	func pages(hostAddress: String) -> [Page] { return [] }
}

struct SinglePageAccessor: PageAccessorProtocol {
	func visit(page: Page) { }
	func all() -> [Page] { return [RealmPage()] }
	func pages(hostAddress: String) -> [Page] { return [RealmPage()] }
}
