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

protocol PageListDependencyInjectorProtocol {

	func pageAccessor() -> PageAccessorProtocol
	func register()
	func registerEmpty()
	func registerSingle()
}

struct DefaultPageListDependencyInjector: PageListDependencyInjectorProtocol {

	static var shared: PageListDependencyInjectorProtocol = DefaultPageListDependencyInjector()
	private let container = Container()

	init() {
		register()
	}

	func register() {
		container.register(PageAccessorProtocol.self) { _ in
			DefaultPageAccessor()
		}
	}

	// Tests
	func registerEmpty() {
		container.register(PageAccessorProtocol.self) { _ in
			EmptyPageAccessor()
		}
	}

	func registerSingle() {
		container.register(PageAccessorProtocol.self) { _ in
			SinglePageAccessor()
		}
	}

	// Resolver
	func pageAccessor() -> PageAccessorProtocol {
		return container.resolve(PageAccessorProtocol.self)!
	}
}
