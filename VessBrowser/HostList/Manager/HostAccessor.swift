import Foundation

/// Access websites

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

/// Test target

struct EmptyHostAccessor: HostAccessorProtocol {
	func visit(host: Host) { }
	func all() -> [Host] { return [] }
}
