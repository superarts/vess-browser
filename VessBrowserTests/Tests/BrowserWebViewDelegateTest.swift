import Quick
import Nimble
@testable import VessBrowser

class BrowserWebViewDelegateTests: QuickSpec, BrowserWebViewDelegatable {
	override func spec() {
		context("BrowserWebViewDelegate") {
			it("should not be nil") {
				let browserWebViewDelegate: BrowserWebViewDelegateProtocol = self.sharedBrowserWebViewDelegateDependencyInjector.browserWebViewDelegate()
				expect(browserWebViewDelegate).toNot(beNil())
				// expect(browserWebViewDelegate.xxx()).toNot(throwError())
			}
		}
	}
}
