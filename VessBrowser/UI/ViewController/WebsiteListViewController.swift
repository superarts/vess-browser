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
                cell.detailTextLabel?.text = website.url.absoluteString
            }
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(Website.self)
            .subscribe(onNext: { website in
                print("LIST selected", website)
				//self.viewModel.nextClosure(topic)
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
	let url: URL
}

struct WebsiteListViewModel {
    var websites = Variable<[Website]>([Website]())

	func setup() {
		let reddit = Website(
			name: "Reddit",
			url: URL(string: "https://www.reddit.com/")!
		)
		websites.value.append(reddit)
	}
}