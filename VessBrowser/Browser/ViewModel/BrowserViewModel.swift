import RxSwift

protocol BrowserViewModelProtocol {
	var page: Variable<Page> { get }
}

struct BrowserViewModel: BrowserViewModelProtocol {
	var page = Variable<Page>(RealmPage())

	init(page: Page) {
		self.page.value = page
	}
}