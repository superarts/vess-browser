import Foundation

/// Access website database

protocol HostDatabaseAccessible: HostDatabaseAccessorDependencyInjectable {
	var hostDatabaseAccessor: RealmDatabaseAccessor<RealmHost> { get }
}

extension HostDatabaseAccessible {
	var hostDatabaseAccessor: RealmDatabaseAccessor<RealmHost> {
		return sharedHostDatabaseAccessorDependencyInjector.hostDatabaseAccessor()
	}
}
