import RealmSwift

/// Access website database

protocol HostDatabaseAccessible: HostDatabaseAccessorDependencyInjectable {
	var hostDatabaseAccessor: HostDatabaseAccessorProtocol { get }
}

extension HostDatabaseAccessible {
	var hostDatabaseAccessor: HostDatabaseAccessorProtocol {
		return sharedHostDatabaseAccessorDependencyInjector.hostDatabaseAccessor()
	}
}

protocol HostDatabaseAccessorProtocol {

	func store(_ host: Host)
	func first(filter: String) -> Host?
	func all() -> [Host]
	func all(filter: String) -> [Host]
}

struct RealmHostDatabaseAccessor: HostDatabaseAccessorProtocol {

	private	let realm = try! Realm()

	func store(_ host: Host) {
		try! realm.write() {
			realm.add(host as! RealmHost)
		}
	}

	func first(filter: String) -> Host? {
		return realm.objects(RealmHost.self).filter(filter).first
	}

	func all() -> [Host] {
		return Array(realm.objects(RealmHost.self))
	}

	func all(filter: String) -> [Host] {
		return Array(realm.objects(RealmHost.self).filter(filter))
	}
}
