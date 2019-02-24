import RealmSwift

///

protocol Storable {
}

protocol Website: Storable {
	var name: String { get }
	var address: String { get }
	var host: String { get }
	var created: Date { get }
}

class RealmWebsite: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var host: String = ""
	@objc dynamic var created: Date = Date()
}

extension RealmWebsite: Website {
}

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

///

protocol WebsiteDatabaseAccessible {
	var databaseAccessorInstance: RealmDatabaseAccessor<RealmWebsite>.Type { get }
}

extension WebsiteDatabaseAccessible {
	var databaseAccessorInstance: RealmDatabaseAccessor<RealmWebsite>.Type {
		return RealmDatabaseAccessor<RealmWebsite>.self
	}
}

///

protocol DatabaseAccessorProtocol {
	associatedtype ModelType

	static func store(_ obj: Storable)
	static func first(filter: String) -> ModelType?
	static func getAll() -> [ModelType]
}

final class RealmDatabaseAccessor<ModelType: RealmSwift.Object>: StatelessObject, DatabaseAccessorProtocol {

	static func store(_ obj: Storable) {
		let realm = try! Realm()
		try! realm.write() {
			realm.add(obj as! RealmSwift.Object)
		}
	}

	static func first(filter: String) -> ModelType? {
		let realm = try! Realm()
		return realm.objects(ModelType.self).filter(filter).first
	}

	static func getAll() -> [ModelType] {
		let realm = try! Realm()
		return Array(realm.objects(ModelType.self))
	}
}

///

protocol WebsiteAccessible: DependencyResolvable {
	var websiteAccessorInstance: WebsiteAccessorProtocol { get }
}

extension WebsiteAccessible {
	var websiteAccessorInstance: WebsiteAccessorProtocol {
		return dependencyResolverInstance.websiteAccessorInstance()
	}
}

protocol WebsiteAccessorProtocol {
	func visit(website: Website)
	func getAll() -> [Website]
}

struct EmptyWebsiteAccessor: WebsiteAccessorProtocol {
	func visit(website: Website) { }
	func getAll() -> [Website] { return [] }
}

struct WebsiteAccessor: WebsiteAccessorProtocol, WebsiteDatabaseAccessible {

	func visit(website: Website) {
		if databaseAccessorInstance.first(filter: "address == \"\(website.address)\"") == nil {
			databaseAccessorInstance.store(website)
		}
	}

	func getAll() -> [Website] {
		let websites = databaseAccessorInstance.getAll()
		return websites.reversed()
	}
}