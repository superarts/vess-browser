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
				cell.load(host: host)
				cell.handleReload = {
					self.viewModel.reload()
					self.tableView.reloadData()
				}

                // Better way to redraw cell circle mask?
                cell.layoutIfNeeded()
                cell.layoutSubviews()
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

class HostListCell: UITableViewCell, HostDatabaseAccessible {
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var addressLabel: UILabel!
	@IBOutlet var detailLabel: UILabel!
	@IBOutlet var priorityLabel: UILabel!
	@IBOutlet var faviconImageView: UIImageView!
	@IBOutlet var priorityUpButton: UIButton!
	@IBOutlet var priorityDownButton: UIButton!

    var handleReload: VoidClosure!

    private var host: Host!

	private let kPriorityBoundary = 999
	private let kPriorityUpTrue = "▲"
	private let kPriorityUpFalse = "△"
	private let kPriorityDownTrue = "▼"
	private let kPriorityDownFalse = "▽"

	func load(host: Host) {
		self.host = host

		faviconImageView.image = UIImage(named: "placeholder-vess.png")
		//faviconImageView.layer.borderWidth = 1
		//faviconImageView.layer.masksToBounds = false
		//faviconImageView.layer.borderColor = UIColor.black.cgColor
		faviconImageView.layer.cornerRadius = faviconImageView.frame.height / 2
		faviconImageView.clipsToBounds = true

		try? FavIcon.downloadPreferred("http://\(host.name)") { result in
			if case let .success(image) = result {
				self.faviconImageView.image = image
			} else {
				self.faviconImageView.sd_setImage(with: URL(string: "http://\(self.host.address)/favicon.ico"))
			}
		}
	}

    override func layoutSubviews() {
        super.layoutSubviews()

		titleLabel.text = host.name
		addressLabel.text = host.address
		detailLabel.text = "Last visited: " + (host.lastTitle == "" ? "N/A" : host.lastTitle)
		priorityLabel.text = host.priority == 0 ? "" : "\(host.priority)"
		if host.priority > 0 {
			titleLabel.textColor = .black
		} else if host.priority == 0 {
			titleLabel.textColor = .darkGray
		} else {
			titleLabel.textColor = .lightGray
		}

		reloadPriority()
	}

	private func reloadPriority() {
		priorityUpButton.setTitle(kPriorityUpFalse, for: .normal)
		priorityDownButton.setTitle(kPriorityDownFalse, for: .normal)
		if host.priority > 0 {
			priorityUpButton.setTitle(kPriorityUpTrue, for: .normal)
		} else if host.priority < 0 {
			priorityDownButton.setTitle(kPriorityDownTrue, for: .normal)
		}
	}

	@IBAction func actionPriorityUp() {
		if host.priority < kPriorityBoundary {
			hostDatabaseAccessor.update(host: host) {
				self.host.priority += 1
				//self.host.updated = Date()
				self.reloadPriority()
				self.handleReload()
			}
		}
	}

	@IBAction func actionPriorityDown() {
		if host.priority > -kPriorityBoundary {
			hostDatabaseAccessor.update(host: host) {
				self.host.priority -= 1
				//self.host.updated = Date()
				self.reloadPriority()
				self.handleReload()
			}
		}
	}
}