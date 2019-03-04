import Swinject

/// Dependency injector for PageDatabaseAccessor

protocol PageDatabaseAccessorDependencyInjectable {
	var sharedPageDatabaseAccessorDependencyInjector: PageDatabaseAccessorDependencyInjectorProtocol { get }
}

extension PageDatabaseAccessorDependencyInjectable {
	var sharedPageDatabaseAccessorDependencyInjector: PageDatabaseAccessorDependencyInjectorProtocol {
		return DefaultPageDatabaseAccessorDependencyInjector.shared
	}
}

protocol PageDatabaseAccessorDependencyInjectorProtocol: EmptyRegistrable {

	func pageDatabaseAccessor() -> PageDatabaseAccessorProtocol
}

struct DefaultPageDatabaseAccessorDependencyInjector: PageDatabaseAccessorDependencyInjectorProtocol {

	static var shared: PageDatabaseAccessorDependencyInjectorProtocol = DefaultPageDatabaseAccessorDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(PageDatabaseAccessorProtocol.self) { _ in
			RealmPageDatabaseAccessor()
		}
	}

	// Resolver
	func pageDatabaseAccessor() -> PageDatabaseAccessorProtocol {
		return container.resolve(PageDatabaseAccessorProtocol.self)!
	}
}
