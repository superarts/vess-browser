import UIKit
import RxSwift
import RxCocoa

class WebsiteListViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!

	var viewModel = WebsiteListViewModel()
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
            .modelSelected(Website.self)
            .subscribe(onNext: { website in
                print("LIST selected", website)
				//self.viewModel.nextClosure(topic)

				let storyboard = UIStoryboard(name: "Browser", bundle: nil)
				guard let controller = storyboard.instantiateViewController(withIdentifier: "BrowserViewController") as? BrowserViewController else {
					fatalError("Browser failed")
				}
				controller.address = website.address
				Navigator.shared.navigationController.pushViewController(controller, animated: true)
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
}

struct Website {
	let name: String
	let address: String
}

struct WebsiteListViewModel {
    var websites = Variable<[Website]>([Website]())

	func setup() {
		let test = Website(
			name: "Test",
			address: "https://www.google.com/search?q=test"
		)
		let reddit = Website(
			name: "Reddit",
			address: "https://www.reddit.com/"
		)
		let youtube = Website(
			name: "YouTube",
			address: "https://www.youtube.com/"
		)
		websites.value.append(contentsOf: [test, reddit, youtube])
	}
}