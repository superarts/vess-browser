import RealmSwift

/// Access web page database

protocol PageDatabaseAccessible: PageDatabaseAccessorDependencyInjectable {
	var pageDatabaseAccessor: PageDatabaseAccessorProtocol { get }
}

extension PageDatabaseAccessible {
	var pageDatabaseAccessor: PageDatabaseAccessorProtocol {
		return sharedPageDatabaseAccessorDependencyInjector.pageDatabaseAccessor()
	}
}

protocol PageDatabaseAccessorProtocol {

	func store(_ Page: Page)
	func first(filter: String) -> Page?
	func all() -> [Page]
	func all(filter: String) -> [Page]
}

struct RealmPageDatabaseAccessor: PageDatabaseAccessorProtocol {

	private	let realm = try! Realm()

	func store(_ page: Page) {
		try! realm.write() {
			realm.add(page as! RealmPage)
		}
	}

	func first(filter: String) -> Page? {
		return realm.objects(RealmPage.self).filter(filter).first
	}

	func all() -> [Page] {
		return Array(realm.objects(RealmPage.self))
	}

	func all(filter: String) -> [Page] {
		return Array(realm.objects(RealmPage.self).filter(filter))
	}
}
