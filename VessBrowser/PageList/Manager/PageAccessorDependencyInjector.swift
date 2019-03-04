import Swinject

/// Dependency injector for PageAccessor

protocol PageAccessorDependencyInjectable {
	var sharedPageAccessorDependencyInjector: PageListDependencyInjectorProtocol { get }
}

extension PageAccessorDependencyInjectable {
	var sharedPageAccessorDependencyInjector: PageListDependencyInjectorProtocol {
		return DefaultPageListDependencyInjector.shared
	}
}

protocol PageListDependencyInjectorProtocol: EmptyRegistrable, SingleRegistrable {

	func pageAccessor() -> PageAccessorProtocol
}

struct DefaultPageListDependencyInjector: PageListDependencyInjectorProtocol {

	static var shared: PageListDependencyInjectorProtocol = DefaultPageListDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(PageAccessorProtocol.self) { _ in
			DefaultPageAccessor()
		}
	}

	// Resolver
	func pageAccessor() -> PageAccessorProtocol {
		return container.resolve(PageAccessorProtocol.self)!
	}
}
