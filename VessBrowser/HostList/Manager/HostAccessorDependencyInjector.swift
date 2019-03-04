import Swinject

// MARK: Dependency injector for HostAccessor

// MARK: - Interface

protocol HostAccessorDependencyInjectable {
	var sharedHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol { get }
}

extension HostAccessorDependencyInjectable {
	var sharedHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol {
		return DefaultHostAccessorDependencyInjector.shared
	}
}

// MARK: - Features

protocol HostAccessorDependencyInjectorProtocol: EmptyRegistrable {

	func hostAccessor() -> HostAccessorProtocol
}

struct DefaultHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol {

	static var shared: HostAccessorDependencyInjectorProtocol = DefaultHostAccessorDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostAccessorProtocol.self) { _ in
			DefaultHostAccessor()
		}
	}

	// Resolver
	func hostAccessor() -> HostAccessorProtocol {
		return container.resolve(HostAccessorProtocol.self)!
	}
}
