import UIKit
import RxSwift
import RxCocoa
import SDWebImage

protocol HostListViewControllerProtocol: ViewControllerConvertable {
	var viewModel: HostListViewModelProtocol! { get set }
	var handleSelectHost: HostClosure! { get set }
	var handleSearch: VoidClosure! { get set }
}

class HostListViewController: UIViewController, HostListViewControllerProtocol {
	
	@IBOutlet var tableView: UITableView!

	var viewModel: HostListViewModelProtocol!
	var handleSelectHost: HostClosure!
	var handleSearch: VoidClosure!

    private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

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
				self.handleSelectHost(host)
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
		self.handleSearch()
	}
}

protocol HostListViewModelProtocol: LifeCycleManagable, HostAccessible {

	var hosts: Variable<[Host]> { get }
}

/**
 * Discussion: How to write test for `HostListViewModel`:
 * - Figure out its features from `HostListViewModelProtocol`
 * - Figure out its dependencies from `HostAccessible`, etc.
 * - Register test dependencies, e.g. `hostAccessorDependencyRegister.registerEmpty()`
 * - Perform tests
 *
 * It is equivalent to the steps from constructor injection, which are like:
 * - Figure out its features from protocol
 * - Figure out its dependencies from constructor
 * - Inject test dependencies from constractor
 * - Perform tests
 */
struct HostListViewModel: HostListViewModelProtocol {
    var hosts = Variable<[Host]>([Host]())
	
	init() {
		//reload()
	}

	/**
	 * Discussion: `reload` is needed because hosts are not automatically updated.
	 * Notification pattern could be used, but it's preferred to make components 
	 * as stateless as possible.
	 */
	func reload() {
		let all = hostAccessor.all()
		print("HOSTLIST count", all.count)
		if !all.isEmpty {
			hosts.value = all
		} else {
			self.loadDefaultHosts()
		}
	}

	private func loadDefaultHosts() {
		let host = RealmHost()
		host.name = "Search"
		host.address = "blank"
		host.created = Date()

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

		//hosts.value.append(contentsOf: [host, reddit, youtube])
		hosts.value = [host]
	}
}