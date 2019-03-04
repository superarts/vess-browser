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

	@IBOutlet private var tableView: UITableView!

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
