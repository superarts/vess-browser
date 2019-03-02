import RealmSwift

///

protocol Storable {
}

///

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

protocol HostDatabaseAccessible {
	var databaseAccessorInstance: RealmDatabaseAccessor<RealmHost>.Type { get }
}

extension HostDatabaseAccessible {
	var databaseAccessorInstance: RealmDatabaseAccessor<RealmHost>.Type {
		return RealmDatabaseAccessor<RealmHost>.self
	}
}

///

protocol DatabaseAccessorProtocol {
	associatedtype ModelType

	static func store(_ obj: Storable)
	static func first(filter: String) -> ModelType?
	static func all() -> [ModelType]
	static func all(filter: String) -> [ModelType]
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

	static func all() -> [ModelType] {
		let realm = try! Realm()
		return Array(realm.objects(ModelType.self))
	}

	static func all(filter: String) -> [ModelType] {
		let realm = try! Realm()
		return Array(realm.objects(ModelType.self).filter(filter))
	}
}

///

protocol WebsiteAccessible: WebsiteAccessorDependencyInjectable {
	var websiteAccessor: WebsiteAccessorProtocol { get }
	//func websiteAccessor() -> WebsiteAccessorProtocol
}

extension WebsiteAccessible {
	var websiteAccessor: WebsiteAccessorProtocol {
	//func websiteAccessor() -> WebsiteAccessorProtocol {
		return sharedWebsiteAccessorDependencyInjector.websiteAccessor()
	}
}

protocol WebsiteAccessorProtocol {
	func visit(website: Website)
	func all() -> [Website]
	func websites(hostAddress: String) -> [Website]
}

struct EmptyWebsiteAccessor: WebsiteAccessorProtocol {
	func visit(website: Website) { }
	func all() -> [Website] { return [] }
	func websites(hostAddress: String) -> [Website] { return [] }
}

struct SingleWebsiteAccessor: WebsiteAccessorProtocol {
	func visit(website: Website) { }
	func all() -> [Website] { return [RealmWebsite()] }
	func websites(hostAddress: String) -> [Website] { return [RealmWebsite()] }
}

struct DefaultWebsiteAccessor: WebsiteAccessorProtocol, WebsiteDatabaseAccessible {

	func visit(website: Website) {
		if databaseAccessorInstance.first(filter: "address == \"\(website.address)\"") == nil {
			databaseAccessorInstance.store(website)
		}
	}

	func all() -> [Website] {
		let websites = databaseAccessorInstance.all()
		return websites.reversed()
	}

	func websites(hostAddress: String) -> [Website] {
		let websites = databaseAccessorInstance.all(filter: "host == \"\(hostAddress)\"")
		return websites.reversed()
	}
}

///

protocol HostAccessible: HostAccessorDependencyInjectable {
	var hostAccessorInstance: HostAccessorProtocol { get }
}

extension HostAccessible {
	var hostAccessorInstance: HostAccessorProtocol {
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

struct HostAccessor: HostAccessorProtocol, HostDatabaseAccessible {

	func visit(host: Host) {
		if databaseAccessorInstance.first(filter: "address == \"\(host.address)\"") == nil {
			databaseAccessorInstance.store(host)
		}
	}

	func all() -> [Host] {
		let hosts = databaseAccessorInstance.all()
		return hosts.reversed()
	}
}
