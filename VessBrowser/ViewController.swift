//
//  ViewController.swift
//  VessBrowser
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

	@IBOutlet var webView: WKWebView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		webView.load(URLRequest(url: URL(string: "https://www.google.com/")!))
	}
}
