//
//  ViewController.swift
//  VessBrowser
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {

	@IBOutlet var webView: WKWebView!
	@IBOutlet var progressBar: UIProgressView!

	var address = "https://www.google.com/search?q=test"

	override func viewDidLoad() {
		super.viewDidLoad()
		webView.navigationDelegate = self
		webView.allowsBackForwardNavigationGestures = true
		webView.load(URLRequest(url: URL(string: address)!))	// TODO
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
		webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
	}

	deinit {
		webView.removeObserver(self, forKeyPath: "estimatedProgress")
		webView.removeObserver(self, forKeyPath: "title")
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "estimatedProgress" {
			print("PROGRESS", webView.estimatedProgress)
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
		}
	}

	func nextBrowser() -> BrowserViewController {
		let storyboard = UIStoryboard(name: "Browser", bundle: nil)
		if let controller = storyboard.instantiateInitialViewController() as? BrowserViewController {
			return controller
		}
		fatalError("BROWSER failed initializing nextBrowser")
	}

	@IBAction func actionBack() {
		webView.goBack()
	}

	@IBAction func actionForward() {
		webView.goForward()
	}

	@IBAction func actionHome() {
		let storyboard = UIStoryboard(name: "WebsiteList", bundle: nil)
		guard let controller = storyboard.instantiateViewController(withIdentifier: "WebsiteListViewController") as? WebsiteListViewController else {
			fatalError("BROWSER failed initializing WebsiteList")
		}
		navigationController?.pushViewController(controller, animated: true)
	}
}

extension BrowserViewController: WKNavigationDelegate, DataStorable {
	func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
		print("COMMIT")
	}

	func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
		print("START")
	}

	func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
		print("REDIRECTION")
	}

	/*
	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		print("CHALLENGE")
	}
	*/

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		print("FAILED", error)
	}

	func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
		print("FAILED provisional nav", error)
	}

	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		print("FINISHED")
		let website = Website()
		website.name = webView.title ?? ""
		website.address = webView.url?.absoluteString ?? ""
		databaseInstance.write(website)
	}

	func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
		print("TERMINATED")
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		print("DECIDE action", navigationAction)
		decisionHandler(.allow)
	}

	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		print("DECIDE response", navigationResponse)
		decisionHandler(.allow)
	}
}
