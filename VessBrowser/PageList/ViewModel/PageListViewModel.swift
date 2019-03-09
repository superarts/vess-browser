import RxCocoa

protocol PageListViewModelProtocol: LifeCycleManagable, PageAccessible {

	var host: BehaviorRelay<Host> { get }
	var pages: BehaviorRelay<[Page]> { get }
	var searchPage: Page { get }
}

/**
* How to write test for `PageListViewModel`:
* - Figure out its features from `PageListViewModelProtocol`
* - Figure out its dependencies from `PageAccessible`, etc.
* - Register test dependencies, e.g. `dependencyRegisterInstance.registerEmptyPageAccessor`
* - Perform tests
*
* It is equivalent to the steps from constructor injection, which are like:
* - Figure out its features from protocol
* - Figure out its dependencies from constructor
* - Inject test dependencies from constractor
* - Perform tests
*/
struct PageListViewModel: PageListViewModelProtocol, HostCreatable, PageCreatable {
	let host: BehaviorRelay<Host>
	var pages = BehaviorRelay<[Page]>(value: [Page]())

	/// The `Page` that is used for search in the current PageList
	var searchPage: Page {
		let address = "https://www.google.com/search?q=\(host.value.name)"
		return pageCreator.page(address: address)
	}

	//private let disposeBag = DisposeBag()

	init(host: Host) {
    	self.host = BehaviorRelay<Host>(value: host)
		//setup()
	}

	func reload() {
		let all = self.pageAccessor.pages(host: host.value)
		print("WEBSITELIST count updated", all.count)
		if !all.isEmpty {
			self.pages.accept(all)
		} else {
			self.loadDefaultPages()
		}
	}

	/*
	private func setup() {
	self.host.asObservable()
	.subscribe(onNext: { host in
	self.reload()
	})
	.disposed(by: disposeBag)
	}
	*/

	private func loadDefaultPages() {
		pages.accept([
			pageCreator.google,
			pageCreator.bing,
			pageCreator.yahoo,
			pageCreator.baidu,
		])
	}
}
