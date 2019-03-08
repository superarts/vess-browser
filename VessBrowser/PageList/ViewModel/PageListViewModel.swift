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
struct PageListViewModel: PageListViewModelProtocol, HostCreatable {
	let host: BehaviorRelay<Host>
	var pages = BehaviorRelay<[Page]>(value: [Page]())

	/// The `Page` that is used for search in the current PageList
	var searchPage: Page {
		let page = RealmPage()
		page.address = "https://www.google.com/search?q=\(host.value.name)"
		return page
	}

	//private let disposeBag = DisposeBag()

	init(host: Host) {
    	self.host = BehaviorRelay<Host>(value: host)
		//setup()
	}

	func reload() {
		let all = self.pageAccessor.pages(hostAddress: host.value.address)
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
		let google = RealmPage()
		google.name = "Google"
		google.address = "https://www.google.com/"
		google.host = "blank"
		google.created = Date()

		let bing = RealmPage()
		bing.name = "Bing"
		bing.address = "https://www.bing.com/"
		bing.host = "blank"
		bing.created = Date()

		let yahoo = RealmPage()
		yahoo.name = "Yahoo"
		yahoo.address = "https://www.yahoo.com/"
		yahoo.host = "blank"
		yahoo.created = Date()

		let baidu = RealmPage()
		baidu.name = "想去莆田用百度，喜送阁下不归路"
		baidu.address = "https://www.baidu.com/"
		baidu.host = "blank"
		baidu.created = Date()

		/*
		let test = RealmPage()
		test.name = "Start Searching Here"
		test.address = "https://www.google.com/search?q=test"
		test.host = "www.google.com"
		test.created = Date()

		let reddit = RealmPage()
		reddit.name = "Reddit"
		reddit.address = "https://www.reddit.com/"
		reddit.host = "www.reddit.com"
		reddit.created = Date()

		let youtube = RealmPage()
		youtube.name = "YouTube"
		youtube.address = "https://www.youtube.com/"
		youtube.host = "www.youtube.com"
		youtube.created = Date()
		*/

		pages.accept([google, bing, yahoo, baidu])
	}
}
