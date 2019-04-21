import WebKit
import RxCocoa

protocol BrowserWebViewModelProtocol {
	var webView: WKWebView { get }
	var progress: BehaviorRelay<Float> { get }
	var title: BehaviorRelay<String> { get }
}

class BrowserWebViewModel: NSObject, BrowserWebViewModelProtocol {

	let webView: WKWebView

	var progress = BehaviorRelay<Float>(value: 0)
	var title = BehaviorRelay<String>(value: "")

	private let kProgress = "estimatedProgress"
	private let kTitle = "title"


	init(webView: WKWebView) {
		self.webView = webView
		super.init()
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
		setup()
	}

	deinit {
		webView.removeObserver(self, forKeyPath: kProgress)
		webView.removeObserver(self, forKeyPath: kTitle)
	}

	private func setup() {
		webView.navigationDelegate = self
		webView.uiDelegate = self
		webView.allowsBackForwardNavigationGestures = true
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == kProgress {
			print("WEBVIEW progress", webView.estimatedProgress)
			progress.accept(Float(webView.estimatedProgress))
		} else if keyPath == kTitle {
			title.accept(webView.title ?? "Untitled")
		}
	}
}

extension BrowserWebViewModel: WKUIDelegate {
	func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
		// Handle target=_blank inside the same WebView
		if navigationAction.targetFrame == nil {
			webView.load(navigationAction.request)
		}
		return nil
	}
}

extension BrowserWebViewModel: WKNavigationDelegate, HostAccessible, PageAccessible, HostCreatable, PageCreatable {

	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("WEBVIEW commit")
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
		print("WEBVIEW finished")
		visit()
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		print("WEBVIEW decide action", navigationAction.request.url?.absoluteString ?? "N/A")
		decisionHandler(.allow)
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		print("WEBVIEW decide response", navigationResponse.response.url?.absoluteString ?? "N/A")
		decisionHandler(.allow)
	}

	private func visit() {
		// TODO: business logic - what if any of these fails?
		if let hostAddress = webView.url?.host {
            hostAccessor.visit(host: hostCreator.host(address: hostAddress, lastTitle: webView.title))
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
