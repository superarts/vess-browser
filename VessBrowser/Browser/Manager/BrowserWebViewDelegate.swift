import Foundation

/// Protocol: BrowserWebViewDelegatable
/// Interface: BrowserWebViewDelegateProtocol
/// Default implementation: DefaultBrowserWebViewDelegate
/// Dependency injector protocol: BrowserWebViewDelegateDependencyInjectable
/// Shared dependency injector: sharedBrowserWebViewDelegateDependencyInjector

// MARK: Protocol

protocol BrowserWebViewDelegatable: BrowserWebViewDelegateDependencyInjectable {
	var browserWebViewDelegate: BrowserWebViewDelegateProtocol { get }
}

extension BrowserWebViewDelegatable {
	var browserWebViewDelegate: BrowserWebViewDelegateProtocol {
		return sharedBrowserWebViewDelegateDependencyInjector.browserWebViewDelegate()
	}
}

// MARK: - Interface

protocol BrowserWebViewDelegateProtocol: HostDatabaseAccessible {
}

// MARK: - Implementation

struct DefaultBrowserWebViewDelegate: BrowserWebViewDelegateProtocol {
}
