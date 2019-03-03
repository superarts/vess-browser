import RealmSwift

///

protocol Storable {
}

///

protocol Page: Storable {
	var name: String { get }
	var address: String { get }
	var host: String { get }
	var created: Date { get }
}

class RealmPage: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var host: String = ""
	@objc dynamic var created: Date = Date()
}

extension RealmPage: Page {
}

///

protocol Host: Storable {
	var name: String { get }
	var address: String { get }
	var favicon: Data { get }
	var created: Date { get }
}

class RealmHost: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var favicon: Data = Data()
	@objc dynamic var created: Date = Date()
}

extension RealmHost: Host {
}

///

protocol PageDatabaseAccessible {
	var pageDatabaseAccessor: RealmDatabaseAccessor<RealmPage> { get }
}

extension PageDatabaseAccessible {
	var pageDatabaseAccessor: RealmDatabaseAccessor<RealmPage> {
		return RealmDatabaseAccessor<RealmPage>()
	}
}

///

protocol HostDatabaseAccessible: HostDatabaseAccessorDependencyInjectable {
	var hostDatabaseAccessor: RealmDatabaseAccessor<RealmHost> { get }
}

extension HostDatabaseAccessible {
	var hostDatabaseAccessor: RealmDatabaseAccessor<RealmHost> {
		return sharedHostDatabaseAccessorDependencyInjector.hostDatabaseAccessor()
	}
}

///

protocol DatabaseAccessorProtocol {
	associatedtype ModelType

	func store(_ obj: Storable)
	func first(filter: String) -> ModelType?
	func all() -> [ModelType]
	func all(filter: String) -> [ModelType]
}

struct RealmDatabaseAccessor<ModelType: RealmSwift.Object>: DatabaseAccessorProtocol {

	private	let realm = try! Realm()

	func store(_ obj: Storable) {
		try! realm.write() {
			realm.add(obj as! RealmSwift.Object)
		}
	}

	func first(filter: String) -> ModelType? {
		return realm.objects(ModelType.self).filter(filter).first
	}

	func all() -> [ModelType] {
		return Array(realm.objects(ModelType.self))
	}

	func all(filter: String) -> [ModelType] {
		return Array(realm.objects(ModelType.self).filter(filter))
	}
}

///

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

///

protocol HostAccessible: HostAccessorDependencyInjectable {
	var hostAccessor: HostAccessorProtocol { get }
}

extension HostAccessible {
	var hostAccessor: HostAccessorProtocol {
		return sharedHostAccessorDependencyInjector.hostAccessor()
	}
}

protocol HostAccessorProtocol {
	func visit(host: Host)
	func all() -> [Host]
}

struct EmptyHostAccessor: HostAccessorProtocol {
	func visit(host: Host) { }
	func all() -> [Host] { return [] }
}

struct DefaultHostAccessor: HostAccessorProtocol, HostDatabaseAccessible {

	func visit(host: Host) {
		if hostDatabaseAccessor.first(filter: "address == \"\(host.address)\"") == nil {
			hostDatabaseAccessor.store(host)
		}
	}

	func all() -> [Host] {
		let hosts = hostDatabaseAccessor.all()
		return hosts.reversed()
	}
}
