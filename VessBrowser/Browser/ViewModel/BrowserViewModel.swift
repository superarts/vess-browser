import RxCocoa

protocol BrowserViewModelProtocol {
	var page: BehaviorRelay<Page> { get }
}

struct BrowserViewModel: BrowserViewModelProtocol {
	let page: BehaviorRelay<Page>

	init(page: Page) {
    	self.page = BehaviorRelay<Page>(value: page)
	}
}
