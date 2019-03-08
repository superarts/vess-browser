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

	/// Go to a certain URL
	func visit(address: String)
}

class BrowserViewController: UIViewController, BrowserViewControllerProtocol {

	@IBOutlet private var webView: WKWebView!
	@IBOutlet private var progressBar: UIProgressView!

	var viewModel: BrowserViewModelProtocol!
	//var webViewViewModel: BrowserWebViewViewModel!
	var handleHome: VoidClosure!
	var handleManualEntry: VoidClosure!
	var handleBack: VoidClosure!

	private let disposeBag = DisposeBag()

	func visit(address: String) {
		// TODO: use viewModel.page instead
		guard let url = URL(string: address) else {
			print("BROWSER invalid URL address", address)
			return
		}
		webView.load(URLRequest(url: url))
	}

	private lazy var backBarButtonItem: UIBarButtonItem = {
		let item = UIBarButtonItem()
		item.image = UIImage(named: "back")
		//item.title = "< Back"
		item.rx.tap.asObservable().subscribe { _ in
			if self.webView.canGoBack {
				self.webView.goBack()
			} else {
				self.handleBack()
			}
		}.disposed(by: self.disposeBag)

		return item
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		//webViewViewModel = BrowserWebViewViewModel(webView: webView)
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.allowsBackForwardNavigationGestures = true
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
		/*
		*/

		viewModel.page.asObservable()
			.subscribe(onNext: { page in
				guard let url = URL(string: page.address) else {
					return
				}
				self.webView.load(URLRequest(url: url))
			})
			.disposed(by: disposeBag)

		navigationItem.leftBarButtonItem = backBarButtonItem
	}

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

	/*
	func nextBrowser() -> BrowserViewController {
	let storyboard = UIStoryboard(name: "Browser", bundle: nil)
	if let controller = storyboard.instantiateInitialViewController() as? BrowserViewController {
	return controller
	}
	fatalError("BROWSER failed initializing nextBrowser")
	}
	*/

	@IBAction private func actionBack() {
		webView.goBack()
	}

	@IBAction private func actionForward() {
		webView.goForward()
	}

	@IBAction private func actionSearch() {
		webView.load(URLRequest(url: URL(string: "https://www.google.com")!))	// TODO
	}

	@IBAction private func actionHome() {
		handleHome()
	}

	@IBAction private func actionManualEntry() {
		handleManualEntry()
	}
}

extension BrowserViewController: WKUIDelegate {
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

		if navigationAction.targetFrame == nil {
			webView.load(navigationAction.request)
		}
		return nil
	}
}

extension BrowserViewController: WKNavigationDelegate, HostAccessible, PageAccessible, HostCreatable, PageCreatable {

	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("COMMIT")
		// TODO: visit with placeholder entry
		visit()
	}

	/*
	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("START")
	}

	func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
		print("REDIRECTION")
	}

	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
	print("CHALLENGE")
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("FAILED", error)
	}

	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print("FAILED provisional nav", error)
	}

	func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
		print("TERMINATED")
	}
	*/

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("FINISHED")
		visit()
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		print("DECIDE action", navigationAction.request.url?.absoluteString ?? "N/A")
		decisionHandler(.allow)
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		print("DECIDE response", navigationResponse.response.url?.absoluteString ?? "N/A")
		decisionHandler(.allow)
	}

	private func visit() {
		// TODO: business logic - what if any of these fails?
		if let hostAddress = webView.url?.host {
			hostAccessor.visit(host: hostCreator.host(name: hostAddress, address: hostAddress))
		}

		if let urlAddress = webView.url?.absoluteString {
			let page = pageCreator.page(
				name: webView.title ?? urlAddress,
				address: urlAddress,
				host: webView.url?.host ?? urlAddress
			)
			pageAccessor.visit(page: page)
		}
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

///

/*
struct BrowserWebViewViewModel {

	private let webView: WKWebView

	init(webView: WKWebView) {
		self.webView = webView
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
		setup()
	}

	deinit {
		webView.removeObserver(self, forKeyPath: "estimatedProgress")
		webView.removeObserver(self, forKeyPath: "title")
	}

	private func setup() {
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.allowsBackForwardNavigationGestures = true
	}

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
}
*/
