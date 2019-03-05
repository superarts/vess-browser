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

protocol HostAccessorProtocol: HostDatabaseAccessible {
	func visit(host: Host)
	func all() -> [Host]
}

struct DefaultHostAccessor: HostAccessorProtocol {

	func visit(host: Host) {
		if var first = hostDatabaseAccessor.first(filter: "address == \"\(host.address)\"") {
			hostDatabaseAccessor.update(host: first) {
				first.updated = Date()
			}
		} else {
			hostDatabaseAccessor.store(host)
		}
	}

	func all() -> [Host] {
		let hosts = hostDatabaseAccessor.all()
		return hosts.reversed()
	}
}