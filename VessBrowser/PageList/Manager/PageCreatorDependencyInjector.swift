import Swinject

/// Dependency injector for PageCreator

// MARK: - Interface

protocol PageCreatorDependencyInjectable {
	var sharedPageCreatorDependencyInjector: PageCreatorDependencyInjectorProtocol { get }
}

extension PageCreatorDependencyInjectable {
	var sharedPageCreatorDependencyInjector: PageCreatorDependencyInjectorProtocol {
		return DefaultPageCreatorDependencyInjector.shared
	}
}

// MARK: - Features

protocol PageCreatorDependencyInjectorProtocol {

	func pageCreator() -> PageCreatorProtocol
}

struct DefaultPageCreatorDependencyInjector: PageCreatorDependencyInjectorProtocol {

	static var shared: PageCreatorDependencyInjectorProtocol = DefaultPageCreatorDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(PageCreatorProtocol.self) { _ in
			DefaultPageCreator()
		}
	}

	// Resolver
	func pageCreator() -> PageCreatorProtocol {
		return container.resolve(PageCreatorProtocol.self)!
	}
}
