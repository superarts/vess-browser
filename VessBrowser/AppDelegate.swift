//
//  AppDelegate.swift
//  VessBrowser
//
//  Created by Leo on 2/14/19.
//  Copyright © 2019 Super Art Software. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppNavigable {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		databaseMigrate()

		window = UIWindow()
		guard let window = window else {
			fatalError("APP no window")
		}

		sharedAppNavigator.setupNavigation(window: window)
		sharedAppNavigator.setRootAsHostList()

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

	// TODO: move out of AppDelegate
	private func databaseMigrate() {
		let version: UInt64 = 2
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: version,

			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion < version) {
					// Nothing to do!
					// Realm will automatically detect new properties and removed properties
					// And will update the schema on disk automatically
				}
			}
		)

		// Tell Realm to use this new configuration object for the default Realm
		Realm.Configuration.defaultConfiguration = config

		// Now that we've told Realm how to handle the schema change, opening the file
		// will automatically perform the migration
		//let realm = try! Realm()
		print("Migration completed to: v\(version)")
	}
}