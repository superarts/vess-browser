import UIKit
import RxSwift
import RxCocoa

protocol PageListViewControllerProtocol: ViewControllerConvertable {
	var viewModel: PageListViewModelProtocol! { get set }
	var handleSelectPage: PageClosure! { get set }
	var handleSearchPage: PageClosure! { get set }
}

// TODO: rename PageList to WebPageList?
class PageListViewController: UIViewController, PageListViewControllerProtocol {

	@IBOutlet var tableView: UITableView!

	var viewModel: PageListViewModelProtocol!
	var handleSelectPage: PageClosure!
	var handleSearchPage: PageClosure!

	private let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		viewModel.pages.asObservable()
			.bind(to: tableView.rx.items(
				cellIdentifier: "PageListCell", cellType: UITableViewCell.self)) { (_, page, cell) in

					cell.textLabel?.text = page.name
					cell.detailTextLabel?.text = page.address
			}
			.disposed(by: disposeBag)

		tableView.rx
			.modelSelected(RealmPage.self)
			.subscribe(onNext: { page in
				print("LIST selected", page)
				self.handleSelectPage(page)
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
		handleSearchPage(viewModel.searchPage)
	}
}
