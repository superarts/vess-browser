import Quick
import Nimble
@testable import VessBrowser

class HostCreatorTests: QuickSpec, HostCreatable {
	override func spec() {
		context("HostCreator") {
			it("should not be nil") {
				let hostCreator: HostCreatorProtocol = self.sharedHostCreatorDependencyInjector.hostCreator()
				expect(hostCreator).toNot(beNil())
				// expect(hostCreator.xxx()).toNot(throwError())
			}
		}
	}
}
