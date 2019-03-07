import Swinject

/// Dependency injector for BrowserWebViewDelegate

// MARK: - Interface

protocol BrowserWebViewDelegateDependencyInjectable {
	var sharedBrowserWebViewDelegateDependencyInjector: BrowserWebViewDelegateDependencyInjectorProtocol { get }
}

extension BrowserWebViewDelegateDependencyInjectable {
	var sharedBrowserWebViewDelegateDependencyInjector: BrowserWebViewDelegateDependencyInjectorProtocol {
		return DefaultBrowserWebViewDelegateDependencyInjector.shared
	}
}

// MARK: - Features

protocol BrowserWebViewDelegateDependencyInjectorProtocol {

	func browserWebViewDelegate() -> BrowserWebViewDelegateProtocol
}

struct DefaultBrowserWebViewDelegateDependencyInjector: BrowserWebViewDelegateDependencyInjectorProtocol {

	static var shared: BrowserWebViewDelegateDependencyInjectorProtocol = DefaultBrowserWebViewDelegateDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(BrowserWebViewDelegateProtocol.self) { _ in
			DefaultBrowserWebViewDelegate()
		}
	}

	// Resolver
	func browserWebViewDelegate() -> BrowserWebViewDelegateProtocol {
		return container.resolve(BrowserWebViewDelegateProtocol.self)!
	}
}
