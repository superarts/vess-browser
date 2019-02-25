import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class HostListViewController: UIViewController, Navigatable {
	
	@IBOutlet var tableView: UITableView!

	var viewModel: HostListViewModelProtocol!
    private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.setup()

        viewModel.hosts.asObservable()
            .bind(to: tableView.rx.items(
                cellIdentifier: "HostListCell", cellType: UITableViewCell.self)) { (_, host, cell) in

                cell.textLabel?.text = host.name
                cell.detailTextLabel?.text = host.address
					cell.imageView?.sd_setImage(with: URL(string: "http://\(host.name)/favicon.ico"), placeholderImage: UIImage(named: "placeholder-vess.png"))
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(RealmHost.self)
            .subscribe(onNext: { host in
                print("LIST selected", host)
				// OR, viewModel -> coordinator -> Navigator
				self.sharedNavigator.pushWebsiteList(host: host)
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
}

protocol HostListViewModelProtocol {

	var hosts: Variable<[Host]> { get }

	func reload()
	func setup()
}

/**
 * How to write test for `HostListViewModel`:
 * - Figure out its features from `HostListViewModelProtocol`
 * - Figure out its dependencies from `HostAccessible`, etc.
 * - Register test dependencies, e.g. `dependencyRegisterInstance.registerEmptyHostAccessor`
 * - Perform tests
 *
 * It is equivalent to the steps from constructor injection, which are like:
 * - Figure out its features from protocol
 * - Figure out its dependencies from constructor
 * - Inject test dependencies from constractor
 * - Perform tests
 */
struct HostListViewModel: HostListViewModelProtocol, HostAccessible {
    var hosts = Variable<[Host]>([Host]())

	func reload() {
		print(hostAccessorInstance.all().count)
		let all = hostAccessorInstance.all()
		if !all.isEmpty {
			hosts.value = hostAccessorInstance.all()
		}
	}

	func setup() {
		let test = RealmHost()
		test.name = "Search"
		test.address = "blank"
		test.created = Date()

		/*
		let reddit = RealmHost()
		reddit.name = "Reddit"
		reddit.address = "https://www.reddit.com/"
		reddit.host = "www.reddit.com"
		reddit.created = Date()

		let youtube = RealmHost()
		youtube.name = "YouTube"
		youtube.address = "https://www.youtube.com/"
		youtube.host = "www.youtube.com"
		youtube.created = Date()
		*/

		//hosts.value.append(contentsOf: [test, reddit, youtube])
		hosts.value.append(test)
	}
}
