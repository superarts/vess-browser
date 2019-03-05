# VessBrowser

A working-in-progress iOS browser. This README file is also WIP.

## Architecture

### MVVM

Other than Navigator it's the usual MVVM approach based on RxSwift. This part will be discussed in details in future.

- View
  - AppNavigator 
  - ViewControllers
- ViewModel
  - Reactive programming
- Model
  - App level models: reflect business logic
  - Low level models, e.g. RealmObjects, network models, etc.
- Helpers and composition: see [Protocol Oriented Programming](#pop)

<a name="pop"></a>
### Protocol Oriented Programming

This project is heavily based on Protocol Oriented Programming, and composition is highly used. 

When a component like this is created, there are several things need to be considered:

- What's the responsibility of this component? Protocol defines the abstraction of its features.
- Who owns this component? Memory management is a consideration for implementation.
- What protocol(s) does this componenet depend on? What about ownership?
- How to replace its dependencies and perform unit test?

Here's an example. Supposed we have need a `HostAccessor` to access visited websites. Features include:

- Visiting a certain `Host` saves data to a database;
- Owner of this accessor can retrive all the visited `Hosts`.

Based on the consideration above, we have the following design:

- Responsibility: it accesses `Hosts`, so the module name would be `HostAccessor`.
- Protocol: its responsibility is defined in `HostAccessorProtocol`.
- Ownership: if a component confirms to `HostAccessible`, it owns a `hostAccessor` from dependency injection:
  - `HostAccessible` must confirm to `HostAccessorDependencyInjectable` protocol, which provides a `sharedHostAccessorDependencyInjector`.
  - Dependency injector is generally a shared instance, as its state needs to be maintained, so that dependencies can be replaced for purposes like testing.
- Dependency: `HostAccessorProtocol` depends on `HostDatabaseAccessible`, which provides access to the actual database.
- Implementation and testing: `DefaultHostAccessor` provides the actual implementation, and stub implementations like `EmptyHostAccessor` are used for testing.
- Mutability and state: unless a component is a shared instance like `sharedHostAccessorDependencyInjector`, it is not only immutable, but also must be totally stateless.
  - Although memory reallocation is an inevitable cost, it's a reasonable price to pay for the sake of code maintainability and testibility.
  - If state needs to be maintained, it should be handled in `ViewModels`.
  - Shared instances should only be used in limited occasions (like Navigator or DependencyInjector - will be discussed in future).

Code of `HostAccessor`:

```
protocol HostAccessible: HostAccessorDependencyInjectable {
	var hostAccessor: HostAccessorProtocol { get }
}

extension HostAccessible {
	var hostAccessor: HostAccessorProtocol {
		return sharedHostAccessorDependencyInjector.hostAccessor()
	}
}

protocol HostAccessorProtocol: HostDatabaseAccessible {
	func visit(host: Host)
	func all() -> [Host]
}

struct DefaultHostAccessor: HostAccessorProtocol {

	func visit(host: Host) {
		if hostDatabaseAccessor.first(filter: "address == \"\(host.address)\"") == nil {
			hostDatabaseAccessor.store(host)
		}
	}

	func all() -> [Host] {
		let hosts = hostDatabaseAccessor.all()
		return hosts.reversed()
	}
}

struct EmptyHostAccessor: HostAccessorProtocol {
	func visit(host: Host) { }
	func all() -> [Host] { return [] }
}

```

Code of `HostAccessorDependencyInjector`:

```

// MARK: - Interface

protocol HostAccessorDependencyInjectable {
	var sharedHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol { get }
}

extension HostAccessorDependencyInjectable {
	var sharedHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol {
		return DefaultHostAccessorDependencyInjector.shared
	}
}

// MARK: - Features

protocol HostAccessorDependencyInjectorProtocol: EmptyRegistrable {

	func hostAccessor() -> HostAccessorProtocol
}

struct DefaultHostAccessorDependencyInjector: HostAccessorDependencyInjectorProtocol {

	static var shared: HostAccessorDependencyInjectorProtocol = DefaultHostAccessorDependencyInjector()
	let container = Container()

	init() {
		register()
	}

	private func register() {
		container.register(HostAccessorProtocol.self) { _ in
			DefaultHostAccessor()
		}
	}

	// Resolver
	func hostAccessor() -> HostAccessorProtocol {
		return container.resolve(HostAccessorProtocol.self)!
	}
}

```

### References

- [Mutability vs MVVM](https://softwareengineering.stackexchange.com/questions/335956/immutable-vs-mutable-mobile-object/388047#388047)