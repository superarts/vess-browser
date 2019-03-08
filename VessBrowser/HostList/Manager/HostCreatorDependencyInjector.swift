import Swinject

/// Dependency injector for HostCreator

// MARK: - Interface

protocol HostCreatorDependencyInjectable {
	var sharedHostCreatorDependencyInjector: HostCreatorDependencyInjectorProtocol { get }
}

extension HostCreatorDependencyInjectable {
	var sharedHostCreatorDependencyInjector: HostCreatorDependencyInjectorProtocol {
		return DefaultHostCreatorDependencyInjector.shared
	}
}

// MARK: - Features

protocol HostCreatorDependencyInjectorProtocol {

	func hostCreator() -> HostCreatorProtocol
}

struct DefaultHostCreatorDependencyInjector: HostCreatorDependencyInjectorProtocol {

	static var shared: HostCreatorDependencyInjectorProtocol = DefaultHostCreatorDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostCreatorProtocol.self) { _ in
			DefaultHostCreator()
		}
	}

	// Resolver
	func hostCreator() -> HostCreatorProtocol {
		return container.resolve(HostCreatorProtocol.self)!
	}
}
