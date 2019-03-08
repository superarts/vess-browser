import Foundation

/// Protocol: HostCreatable
/// Interface: HostCreatorProtocol
/// Default implementation: DefaultHostCreator
/// Dependency injector protocol: HostCreatorDependencyInjectable
/// Shared dependency injector: sharedHostCreatorDependencyInjector

// MARK: Protocol

protocol HostCreatable: HostCreatorDependencyInjectable {
	var hostCreator: HostCreatorProtocol { get }
}

extension HostCreatable {
	var hostCreator: HostCreatorProtocol {
		return sharedHostCreatorDependencyInjector.hostCreator()
	}
}

// MARK: - Interface

protocol HostCreatorProtocol: HostDatabaseAccessible {
	var empty: Host { get }
	var blank: Host { get }
	var google: Host { get }
	func host(name: String, address: String) -> Host
}

// MARK: - Implementation

struct DefaultHostCreator: HostCreatorProtocol {
	var empty: Host {
		return RealmHost()
	}

	var blank: Host {
		let host = RealmHost()
		host.name = "Search"
		host.address = "blank"
		return host
	}

	var google: Host {
		let host = RealmHost()
		host.name = "Google"
		host.address = "https://www.google.com/"
		return host
	}

	func host(name: String, address: String) -> Host {
		let host = RealmHost()
		host.name = name
		host.address = address
		return host
	}
}
