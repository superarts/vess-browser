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
    func host(address: String) -> Host
    func host(address: String, lastTitle: String?) -> Host
}

// MARK: - Implementation

struct DefaultHostCreator: HostCreatorProtocol {
	var empty: Host {
		return RealmHost()
	}

	var blank: Host {
		let host = RealmHost()
		host.name = "Search"
		host.address = "Tap here to start"
		return host
	}

	var google: Host {
		let host = RealmHost()
		host.name = "Google"
		host.address = "https://www.google.com/"
		return host
	}

    // MARK: - Constructors

    func host(name: String, address: String) -> Host {
        let host = RealmHost()
        host.name = name
        host.address = address
        return host
    }

    func host(address: String) -> Host {
        let host = RealmHost()
        host.name = uppercaseFirst(string: domainName(address: address))
        host.address = address
        return host
    }

    func host(address: String, lastTitle: String?) -> Host {
		let host = RealmHost()
        host.name = uppercaseFirst(string: domainName(address: address))
		host.address = address
        if let lastTitle = lastTitle {
            host.lastTitle = lastTitle
        }
		return host
	}

    // TODO: put in a String Utility helper
    private func domainName(address: String) -> String {
        let componenets = address.components(separatedBy: ".")
        return (componenets.count > 1) ? componenets[1] : address
    }

    private func uppercaseFirst(string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
}
