import RealmSwift

///

protocol Storable {
}

protocol Website: Storable {
	var name: String { get }
	var address: String { get }
}

class RealmWebsite: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	/*
	required init(name: String, address: String) {
		super.init()
		self.name = name
		self.address = address
	}
	*/
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

// TODO: how to use protocol/struct over class?
// - Instead of using Stateless, StatelessObject makes more sense since
// Stateless is implementation detail rather than interface contract.
/*
protocol Stateless {
init()
}

extension Stateless {
init() {
fatalError("test")
}
}
*/

///

// TODO: how to make DatabaseAccessible & DatabaseAccessor not depend on a
// specific database implementation?
/*
protocol DatabaseAccessible {
	/*
	associatedtype DatabaseAccessorType: RealmSwift.Object
	var databaseAccessorInstance: DatabaseAccessor<DatabaseAccessorType>.Type { get }
	//var databaseAccessorInstance: DatabaseAccessorProtocol.Type { get }
	*/

	associatedtype DatabaseAccessorType: DatabaseAccessorProtocol
	//associatedtype DatabaseAccessorObjectType
	var databaseAccessorInstance: DatabaseAccessorType.Type { get }
}

extension DatabaseAccessible {
	/*
	var databaseAccessorInstance: DatabaseAccessor<DatabaseAccessorType>.Type {
		return DatabaseAccessor<DatabaseAccessorType>.self
	}
    */
	var databaseAccessorInstance: DatabaseAccessorType.Type {
		//return RealmDataAccessor<DatabaseAccessorObjectType>.self as! DatabaseAccessorType.Type
		//return SimpleDependencyContainer.databaseAccessorType() as! DatabaseAccessorType.Type
		return DatabaseAccessorType.self
	}
}
*/

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

protocol StubWebsiteDatabaseAccessible {
	var databaseAccessorInstance: StubDatabaseAccessor<Website>.Type { get }
}

extension StubWebsiteDatabaseAccessible {
	var databaseAccessorInstance: StubDatabaseAccessor<Website>.Type {
		return StubDatabaseAccessor<Website>.self
	}
}

/*
struct SimpleDependencyContainer {
	static func databaseAccessorType() -> RealmDataAccessor<Website>.Type {
		return RealmDataAccessor<Website>.self
	}
}

struct Test<T: DatabaseAccessorProtocol> {
	var test: T?
}

struct Factory {
	func test() {
        var t = Test<RealmDataAccessor<Website>>()
        t.test = RealmDataAccessor<Website>()
	}
}
*/

protocol DatabaseAccessorProtocol {
	associatedtype ModelType

	static func store(_ obj: Storable)
	static func first(filter: String) -> ModelType?
	static func getAll() -> [ModelType]
}

protocol WebsiteDatabaseAccessorProtocol: DatabaseAccessorProtocol where ModelType == Website {
}

/*
extension WebsiteDatabaseAccessorProtocol where ModelType == Website {
}
*/

struct StubDatabaseAccessor<ModelType>: DatabaseAccessorProtocol {
	static func store(_ obj: Storable) {
	}

	static func first(filter: String) -> ModelType? {
		return nil
	}

	static func getAll() -> [ModelType] {
		return []
	}
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

/*
struct Box<T: DatabaseAccessorProtocol> {
	typealias U = T

	let objectType: U.Type
	let object: U

	init(object: U) {
		self.object = object
		self.objectType = U.self
	}
	// Box<RealmDatabaseAccessor<RealmSwift.Object>>(object: RealmDatabaseAccessor<RealmSwift.Object>())
}

let box = Box<RealmDatabaseAccessor<RealmSwift.Object>>(object: RealmDatabaseAccessor<RealmSwift.Object>())
*/
///

protocol WebsiteAccessible: DependencyResolvable {
	var websiteAccessorInstance: WebsiteAccessorProtocol { get }
}

extension WebsiteAccessible {
	var websiteAccessorInstance: WebsiteAccessorProtocol {
		//return WebsiteAccessor<RealmDatabaseAccessor<RealmWebsite>>()
		//return WebsiteAccessor()
		return dependencyResolverInstance.websiteAccessorInstance()
	}
}

// TODO: How to make WebsiteProvider a StatelessObject?
/*
struct WebsiteProvider: DatabaseAccessible {
	typealias DatabaseAccessorType = Website

	func visit(website: Website) {
		if databaseAccessorInstance.first(filter: "address == \"\(website.address)\"") == nil {
			databaseAccessorInstance.add(website)
		}
	}

	func getAll() -> [Website] {
		return databaseAccessorInstance.getAll()
	}
}
*/

protocol WebsiteAccessorProtocol {
	func visit(website: Website)
	func getAll() -> [Website]
}

struct EmptyWebsiteAccessor: WebsiteAccessorProtocol {
	func visit(website: Website) { }
	func getAll() -> [Website] { return [] }
}

// TODO: Provider should not depend on Realm
struct WebsiteAccessor: WebsiteAccessorProtocol, WebsiteDatabaseAccessible {
//struct WebsiteProvider: StubWebsiteDatabaseAccessible {
//struct WebsiteAccessor<WebsiteAccessorType: WebsiteDatabaseAccessorProtocol>: DatabaseAccessible {
//struct WebsiteAccessor: WebsiteAccessorProtocol, DatabaseAccessible {
//struct WebsiteProvider {

	// We have this dependency and it cannot be resolved at runtime
	//typealias DatabaseAccessorType = WebsiteAccessorType
	//typealias DatabaseAccessorType = RealmDatabaseAccessor<RealmWebsite>
	//typealias DatabaseAccessorObjectType = Website

	// Without T in WebsiteProvider<T>, WebsiteProvider cannot figure out DatabaseAccessorType
	//let databaseAccessorInstance: DatabaseAccessorProtocol = RealmDatabaseAccessor<RealmWebsite>()
	//let databaseAccessorInstance = RealmDatabaseAccessor<RealmWebsite>.self

	func visit(website: Website) {
		if databaseAccessorInstance.first(filter: "address == \"\(website.address)\"") == nil {
			databaseAccessorInstance.store(website)
		}
	}

	func getAll() -> [Website] {
		return databaseAccessorInstance.getAll()
	}

	//let accessor: DatabaseAccessorProtocol = RealmDatabaseAccessor<RealmWebsite>()
}

/*
struct WebsiteAccessorTest {
	func test() {
		let accessor = WebsiteAccessor<RealmDatabaseAccessor<RealmWebsite>>()
		assert(accessor.getAll().count > -1)
	}
}
*/