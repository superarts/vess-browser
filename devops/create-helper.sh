#!/bin/bash

# TODO: check if under project root directory

if [ "$#" -ne 3 ]; then
	echo Example: devops/create-helper.sh BrowserWebViewDelegatable BrowserWebViewDelegate Browser
	echo '$1: protocol, e.g. HostAccessible'
	echo '$2: implmentation, e.g. HostAccessor'
	echo '$3: module, e.g. HostList'
	exit
fi

class=$2
instance=`echo ${class:0:1} | tr  '[A-Z]' '[a-z]'`${class:1}

cat << EOF > VessBrowser/$3/Manager/$2.swift
import Foundation

/// Protocol: $1
/// Interface: $2Protocol
/// Default implementation: Default$2
/// Dependency injector protocol: $2DependencyInjectable
/// Shared dependency injector: shared$2DependencyInjector

// MARK: Protocol

protocol $1: $2DependencyInjectable {
	var $instance: $2Protocol { get }
}

extension $1 {
	var $instance: $2Protocol {
		return shared$2DependencyInjector.$instance()
	}
}

// MARK: - Interface

protocol $2Protocol: HostDatabaseAccessible {
}

// MARK: - Implementation

struct Default$2: $2Protocol {
}
EOF

cat << EOF > VessBrowser/$3/Manager/$2DependencyInjector.swift
import Swinject

/// Dependency injector for $2

// MARK: - Interface

protocol $2DependencyInjectable {
	var shared$2DependencyInjector: $2DependencyInjectorProtocol { get }
}

extension $2DependencyInjectable {
	var shared$2DependencyInjector: $2DependencyInjectorProtocol {
		return Default$2DependencyInjector.shared
	}
}

// MARK: - Features

protocol $2DependencyInjectorProtocol {

	func $instance() -> $2Protocol
}

struct Default$2DependencyInjector: $2DependencyInjectorProtocol {

	static var shared: $2DependencyInjectorProtocol = Default$2DependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register($2Protocol.self) { _ in
			Default$2()
		}
	}

	// Resolver
	func $instance() -> $2Protocol {
		return container.resolve($2Protocol.self)!
	}
}
EOF

cat << EOF > VessBrowserTests/Tests/$2Test.swift
import Quick
import Nimble
@testable import VessBrowser

class $2Tests: QuickSpec, $1 {
	override func spec() {
		context("$2") {
			it("should not be nil") {
				let $instance: $2Protocol = self.shared$2DependencyInjector.$instance()
				expect($instance).toNot(beNil())
				// expect($instance.xxx()).toNot(throwError())
			}
		}
	}
}
EOF

echo Add to App: VessBrowser/$3/Manager/$2.swift
echo Add to App: VessBrowser/$3/Manager/$2DependencyInjector.swift
echo Add to Test: VessBrowserTests/Tests/$2Test.swift
git status

open VessBrowser/$3/Manager/
open VessBrowserTests/Tests/