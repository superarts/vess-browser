import UIKit
import RxSwift
import RxCocoa

protocol WebsiteListViewControllerProtocol {
	var viewModel: WebsiteListViewModelProtocol! { get set }
}

// TODO: rename WebsiteList to WebPageList?
class WebsiteListViewController: UIViewController, WebsiteListViewControllerProtocol, AppNavigatable {
	
	@IBOutlet var tableView: UITableView!

	var viewModel: WebsiteListViewModelProtocol!
    private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.setup()

        viewModel.websites.asObservable()
            .bind(to: tableView.rx.items(
                cellIdentifier: "WebsiteListCell", cellType: UITableViewCell.self)) { (_, website, cell) in

                cell.textLabel?.text = website.name
                cell.detailTextLabel?.text = website.address
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(RealmWebsite.self)
            .subscribe(onNext: { website in
                print("LIST selected", website)
				self.sharedAppNavigator.pushBrowser(website: website)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                print("LIST tapped", indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.reload()
	}

	@IBAction func actionSearch() {
		sharedAppNavigator.pushBrowser(website: viewModel.searchWebsite())
	}
}

protocol WebsiteListViewModelProtocol: WebsiteAccessible {

	var websites: Variable<[Website]> { get }

	func reload()
	func setup()
	func searchWebsite() -> Website
}

/**
 * How to write test for `WebsiteListViewModel`:
 * - Figure out its features from `WebsiteListViewModelProtocol`
 * - Figure out its dependencies from `WebsiteAccessible`, etc.
 * - Register test dependencies, e.g. `dependencyRegisterInstance.registerEmptyWebsiteAccessor`
 * - Perform tests
 *
 * It is equivalent to the steps from constructor injection, which are like:
 * - Figure out its features from protocol
 * - Figure out its dependencies from constructor
 * - Inject test dependencies from constractor
 * - Perform tests
 */
struct WebsiteListViewModel: WebsiteListViewModelProtocol {
    var websites = Variable<[Website]>([Website]())

	private var host: Host

	init(host: Host) {
		self.host = host
	}

	func reload() {
		print(websiteAccessor.all().count)
		let all = websiteAccessor.websites(hostAddress: host.address)
		if !all.isEmpty {
			websites.value = all
		}
	}

	func setup() {
		let google = RealmWebsite()
		google.name = "Google"
		google.address = "https://www.google.com/"
		google.host = "blank"
		google.created = Date()

		let bing = RealmWebsite()
		bing.name = "Bing"
		bing.address = "https://www.bing.com/"
		bing.host = "blank"
		bing.created = Date()

		let yahoo = RealmWebsite()
		yahoo.name = "Yahoo"
		yahoo.address = "https://www.yahoo.com/"
		yahoo.host = "blank"
		yahoo.created = Date()

		let baidu = RealmWebsite()
		baidu.name = "想去莆田用百度，喜送阁下不归路"
		baidu.address = "https://www.baidu.com/"
		baidu.host = "blank"
		baidu.created = Date()

		/*
		let test = RealmWebsite()
		test.name = "Start Searching Here"
		test.address = "https://www.google.com/search?q=test"
		test.host = "www.google.com"
		test.created = Date()

		let reddit = RealmWebsite()
		reddit.name = "Reddit"
		reddit.address = "https://www.reddit.com/"
		reddit.host = "www.reddit.com"
		reddit.created = Date()

		let youtube = RealmWebsite()
		youtube.name = "YouTube"
		youtube.address = "https://www.youtube.com/"
		youtube.host = "www.youtube.com"
		youtube.created = Date()
		*/

		websites.value.append(contentsOf: [google, bing, yahoo, baidu])
	}

	func searchWebsite() -> Website {
		let website = RealmWebsite()
		website.address = "https://www.google.com/search?q=\(host.name)"
		return website
	}
}