//
//  AppTests.swift
//  VessBrowserTests
//
//  Created by Leo on 3/3/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import Quick
import Nimble
@testable import VessBrowser

/**
Discussion: we are testing implementation instead of protocol for the following components:
- UIKit componenets, due to things like `viewDidLoad`, `applicationDidFinishLaunching` etc.
- `AppTestable` components, because `testApp()` is an add-on to a specific implementation
*/

class AppTests: QuickSpec, AppNavigatorDependencyInjectable, TestModelProvidable, HostCreatable {

	override func spec() {

		let host = hostCreator.empty
		let page = testModelProvider.GooglePage

		describe("Application") {
			context("Navigator") {
				it("is AppNavigator") {
					let navigator = DefaultAppNavigator()
					expect(navigator.setupNavigation(window: UIWindow())).toNot(throwError())
					expect(navigator.setRootAsHostList()).toNot(throwError())
					expect(navigator.testApp()).toNot(throwError())
				}
			}
		}
		describe("UIKit") {
			context("App") {
				it("is AppDelegate") {
					let appDelegate = AppDelegate()
					expect(appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)).to(beTrue())
					expect(appDelegate.applicationWillResignActive(UIApplication.shared)).toNot(throwError())
					expect(appDelegate.applicationDidEnterBackground(UIApplication.shared)).toNot(throwError())
					expect(appDelegate.applicationWillEnterForeground(UIApplication.shared)).toNot(throwError())
					expect(appDelegate.applicationDidBecomeActive(UIApplication.shared)).toNot(throwError())
					expect(appDelegate.applicationWillTerminate(UIApplication.shared)).toNot(throwError())
				}
			}
			context("ViewController") {
				it("is HostListViewController") {
					let controller = self.sharedAppNavigatorDependencyInjector.hostListViewController() as! HostListViewController
					expect(controller.loadView()).toNot(throwError())
					expect(controller.viewDidLoad()).toNot(throwError())
					expect(controller.viewWillAppear(true)).toNot(throwError())
					/*
					expect(controller.tableView).toNot(beNil())
					expect(controller.viewModel).toNot(beNil())
					expect(controller.handleSelectHost = { _ in } ).toNot(throwError())
					expect(controller.handleSelectHost).toNot(beNil())
					*/
					expect(controller.handleSearch = { } ).toNot(throwError())
					//expect(controller.handleSearch).toNot(beNil())
					expect(controller.testApp()).toNot(throwError())
				}
				it("is PageListViewController") {
					let controller = self.sharedAppNavigatorDependencyInjector.pageListViewController(host: host) as! PageListViewController
					expect(controller.loadView()).toNot(throwError())
					expect(controller.viewDidLoad()).toNot(throwError())
					expect(controller.viewWillAppear(true)).toNot(throwError())
					expect(controller.handleSearchPage = { _ in } ).toNot(throwError())
					expect(controller.testApp()).toNot(throwError())
				}
				it("is BrowserViewController") {
					let controller = self.sharedAppNavigatorDependencyInjector.browserViewController(page: page) as! BrowserViewController
					expect(controller.loadView()).toNot(throwError())
					expect(controller.viewDidLoad()).toNot(throwError())
					expect(controller.visit(address: "https://www.google.com")).toNot(throwError())
					expect(controller.handleHome = { } ).toNot(throwError())
					expect(controller.handleManualEntry = { } ).toNot(throwError())
					expect(controller.testApp()).toNot(throwError())
				}
			}
		}
	}
}
