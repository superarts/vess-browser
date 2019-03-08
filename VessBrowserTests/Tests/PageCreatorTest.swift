import Quick
import Nimble
@testable import VessBrowser

class PageCreatorTests: QuickSpec, PageCreatable {
	override func spec() {
		context("PageCreator") {
			it("should not be nil") {
				let pageCreator: PageCreatorProtocol = self.sharedPageCreatorDependencyInjector.pageCreator()
				expect(pageCreator).toNot(beNil())
				// expect(pageCreator.xxx()).toNot(throwError())
			}
		}
	}
}
