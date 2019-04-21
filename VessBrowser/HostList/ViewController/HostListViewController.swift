import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import FavIcon

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

		tableView
			.rx.setDelegate(self)
			.disposed(by: disposeBag)

		viewModel.hosts.asObservable()
			.bind(to: tableView.rx.items(
				cellIdentifier: "HostListCell", cellType: HostListCell.self)) { (_, host, cell) in

				cell.titleLabel.text = host.name
				cell.addressLabel.text = host.address
				cell.detailLabel.text = "Last visited: " + (host.lastTitle == "" ? "N/A" : host.lastTitle)
				cell.faviconImageView.image = UIImage(named: "placeholder-vess.png")
				//cell.faviconImageView.layer.borderWidth = 1
				//cell.faviconImageView.layer.masksToBounds = false
				//cell.faviconImageView.layer.borderColor = UIColor.black.cgColor
				cell.faviconImageView.layer.cornerRadius = cell.faviconImageView.frame.width / 2
				cell.faviconImageView.clipsToBounds = true
				try? FavIcon.downloadPreferred("http://\(host.name)") { result in
					if case let .success(image) = result {
						cell.faviconImageView.image = image
					} else {
        				cell.faviconImageView.sd_setImage(with: URL(string: "http://\(host.address)/favicon.ico"))
					}
				}
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

	@IBAction private func actionSearch() {
		self.handleSearch()
	}
}

extension HostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 64
	}
}

// MARK: - AppTestable

extension HostListViewController: AppTestable {
	func testApp() {
		actionSearch()
	}
}

// MARK: - HostListCell

class HostListCell: UITableViewCell {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var addressLabel: UILabel!
	@IBOutlet var detailLabel: UILabel!
	@IBOutlet var faviconImageView: UIImageView!
}