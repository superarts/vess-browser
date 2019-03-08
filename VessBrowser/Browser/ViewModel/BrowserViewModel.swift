import RxCocoa

protocol BrowserViewModelProtocol {
	var page: BehaviorRelay<Page> { get }
}

struct BrowserViewModel: BrowserViewModelProtocol {
	var page = BehaviorRelay<Page>(value: RealmPage())

	init(page: Page) {
		self.page.accept(page)
	}
}
