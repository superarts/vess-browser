import Swinject

/// Dependency injector for HostDatabaseAccessor

protocol HostDatabaseAccessorDependencyInjectable {
	var sharedHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol { get }
}

extension HostDatabaseAccessorDependencyInjectable {
	var sharedHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol {
		return DefaultHostDatabaseAccessorDependencyInjector.shared
	}
}

protocol HostDatabaseAccessorDependencyInjectorProtocol: EmptyRegistrable {

	func hostDatabaseAccessor() -> HostDatabaseAccessorProtocol
}

struct DefaultHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol {

	static var shared: HostDatabaseAccessorDependencyInjectorProtocol = DefaultHostDatabaseAccessorDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostDatabaseAccessorProtocol.self) { _ in
			RealmHostDatabaseAccessor()
		}
	}

	// Resolver
	func hostDatabaseAccessor() -> HostDatabaseAccessorProtocol {
		return container.resolve(HostDatabaseAccessorProtocol.self)!
	}
}
