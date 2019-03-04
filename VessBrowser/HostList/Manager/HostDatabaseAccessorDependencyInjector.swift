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

protocol HostDatabaseAccessorDependencyInjectorProtocol {

	func hostDatabaseAccessor() -> RealmDatabaseAccessor<RealmHost>
	//func registerEmpty()
}

struct DefaultHostDatabaseAccessorDependencyInjector: HostDatabaseAccessorDependencyInjectorProtocol {

	static var shared: HostDatabaseAccessorDependencyInjectorProtocol = DefaultHostDatabaseAccessorDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(RealmDatabaseAccessor<RealmHost>.self) { _ in
			RealmDatabaseAccessor<RealmHost>()
		}
	}

	/*
	func registerEmpty() {
	container.register(HostAccessorProtocol.self) { _ in
	EmptyHostAccessor()
	}
	}
	*/

	// Resolver
	func hostDatabaseAccessor() -> RealmDatabaseAccessor<RealmHost> {
		return container.resolve(RealmDatabaseAccessor<RealmHost>.self)!
	}
}
