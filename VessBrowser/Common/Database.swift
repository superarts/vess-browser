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

///

protocol WebsiteDatabaseAccessible {
	var websiteDatabaseAccessor: RealmDatabaseAccessor<RealmWebsite> { get }
}

extension WebsiteDatabaseAccessible {
	var websiteDatabaseAccessor: RealmDatabaseAccessor<RealmWebsite> {
		return RealmDatabaseAccessor<RealmWebsite>()
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

/*
protocol HostDatabaseAccessorProtocol {

	func store(_ obj: Storable)
	func first(filter: String) -> Host?
	func all() -> [Host]
	func all(filter: String) -> [Host]
}

struct RealmDatabaseAccessor<ModelType: RealmSwift.Object>: DatabaseAccessorProtocol, HostDatabaseAccessorProtocol { }
*/

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

struct EmptyDatabaseAccessor<ModelType: RealmSwift.Object>: DatabaseAccessorProtocol {

	private	let realm = try! Realm()

	func store(_ obj: Storable) {
	}

	func first(filter: String) -> ModelType? {
		return nil
	}

	func all() -> [ModelType] {
		return []
	}

	func all(filter: String) -> [ModelType] {
		return []
	}
}

///

protocol WebsiteAccessible: WebsiteAccessorDependencyInjectable {
	var websiteAccessor: WebsiteAccessorProtocol { get }
}

extension WebsiteAccessible {
	var websiteAccessor: WebsiteAccessorProtocol {
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
		if websiteDatabaseAccessor.first(filter: "address == \"\(website.address)\"") == nil {
			websiteDatabaseAccessor.store(website)
		}
	}

	func all() -> [Website] {
		let websites = websiteDatabaseAccessor.all()
		return websites.reversed()
	}

	func websites(hostAddress: String) -> [Website] {
		let websites = websiteDatabaseAccessor.all(filter: "host == \"\(hostAddress)\"")
		return websites.reversed()
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