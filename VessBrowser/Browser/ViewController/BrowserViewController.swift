import UIKit
import WebKit
import RxSwift

protocol BrowserViewControllerProtocol: ViewControllerConvertable {

	var viewModel: BrowserViewModelProtocol! { get set }

	/// When user selects home
	var handleHome: VoidClosure! { get set }

	/// When user tries to enter URL manually
	var handleManualEntry: VoidClosure! { get set }

	/// When user goes back from browser
	var handleBack: VoidClosure! { get set }

	/// Go to a certain Page
	func visit(page: Page)
}

class BrowserViewController: UIViewController, BrowserViewControllerProtocol {

	@IBOutlet private var webView: WKWebView!
	@IBOutlet private var progressBar: UIProgressView!

	var viewModel: BrowserViewModelProtocol!
	var webViewModel: BrowserWebViewModelProtocol!
	var handleHome: VoidClosure!
	var handleManualEntry: VoidClosure!
	var handleBack: VoidClosure!

	private let disposeBag = DisposeBag()

	func visit(page: Page) {
		// TODO: use viewModel.page instead
		guard let url = URL(string: page.address) else {
			print("BROWSER invalid page", page)
			return
		}
		webViewModel.webView.load(URLRequest(url: url))
	}

	private lazy var backBarButtonItem: UIBarButtonItem = {
		let item = UIBarButtonItem()
		item.image = UIImage(named: "back")
		//item.title = "< Back"
		item.rx.tap.asObservable().subscribe { _ in
			if self.webViewModel.webView.canGoBack {
				self.webViewModel.webView.goBack()
			} else {
				self.handleBack()
			}
		}.disposed(by: self.disposeBag)

		return item
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		webViewModel = BrowserWebViewModel(webView: webView)
		webViewModel.title.asObservable()
			.subscribe(onNext: { title in
				self.title = title
			})
			.disposed(by: disposeBag)
		webViewModel.progress.asObservable()
			.subscribe(onNext: { progress in
				self.progressBar.progress = progress
				if progress == 1 {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
						self.progressBar.progress = 0
						self.progressBar.isHidden = true
					}
				} else {
					self.progressBar.isHidden = false
				}
			})
			.disposed(by: disposeBag)
		/*
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.allowsBackForwardNavigationGestures = true
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
		*/

		viewModel.page.asObservable()
			.subscribe(onNext: { page in
				guard let url = URL(string: page.address) else {
					return
				}
				self.webViewModel.webView.load(URLRequest(url: url))
			})
			.disposed(by: disposeBag)

		navigationItem.leftBarButtonItem = backBarButtonItem
	}

	/*
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			print("PROGRESS", webView.estimatedProgress)
			//progressBar.alpha = CGFloat(1 - webView.estimatedProgress)
			progressBar.progress = Float(webView.estimatedProgress)
			if webView.estimatedProgress == 1 {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
					self.progressBar.progress = 0
					self.progressBar.isHidden = true
				}
			} else {
				progressBar.isHidden = false
			}
		} else if keyPath == "title" {
			title = webView.title
			//navigationItem.prompt = viewModel.page.value.address
    		//navigationItem.leftBarButtonItem = backBarButtonItem
		}
	}

	func nextBrowser() -> BrowserViewController {
		let storyboard = UIStoryboard(name: "Browser", bundle: nil)
			if let controller = storyboard.instantiateInitialViewController() as? BrowserViewController {
				return controller
			}
		fatalError("BROWSER failed initializing nextBrowser")
	}
	*/

	@IBAction private func actionBack() {
		webViewModel.webView.goBack()
	}

	@IBAction private func actionForward() {
		webViewModel.webView.goForward()
	}

	@IBAction private func actionSearch() {
		webViewModel.webView.load(URLRequest(url: URL(string: "https://www.google.com")!))	// TODO
	}

	@IBAction private func actionHome() {
		handleHome()
	}

	@IBAction private func actionManualEntry() {
		handleManualEntry()
	}
}

// MARK: - AppTestable

extension BrowserViewController: AppTestable {
	func testApp() {
		actionBack()
		actionForward()
		actionSearch()
		actionHome()
		actionManualEntry()
	}
}
