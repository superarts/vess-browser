import RxSwift

protocol HostListViewModelProtocol: LifeCycleManagable, HostAccessible {

	var hosts: Variable<[Host]> { get }
}

/**
* Discussion: How to write test for `HostListViewModel`:
* - Figure out its features from `HostListViewModelProtocol`
* - Figure out its dependencies from `HostAccessible`, etc.
* - Register test dependencies, e.g. `hostAccessorDependencyRegister.registerEmpty()`
* - Perform tests
*
* It is equivalent to the steps from constructor injection, which are like:
* - Figure out its features from protocol
* - Figure out its dependencies from constructor
* - Inject test dependencies from constractor
* - Perform tests
*/
struct HostListViewModel: HostListViewModelProtocol {
	var hosts = Variable<[Host]>([Host]())

	init() {
		//reload()
	}

	/**
	* Discussion: `reload` is needed because hosts are not automatically updated.
	* Notification pattern could be used, but it's preferred to make components
	* as stateless as possible.
	*/
	func reload() {
		let all = hostAccessor.all()
		print("HOSTLIST count", all.count)
		if !all.isEmpty {
			hosts.value = all
		} else {
			self.loadDefaultHosts()
		}
	}

	private func loadDefaultHosts() {
		let host = RealmHost()
		host.name = "Search"
		host.address = "blank"
		host.created = Date()

		/*
		let reddit = RealmHost()
		reddit.name = "Reddit"
		reddit.address = "https://www.reddit.com/"
		reddit.host = "www.reddit.com"
		reddit.created = Date()

		let youtube = RealmHost()
		youtube.name = "YouTube"
		youtube.address = "https://www.youtube.com/"
		youtube.host = "www.youtube.com"
		youtube.created = Date()
		*/

		//hosts.value.append(contentsOf: [host, reddit, youtube])
		hosts.value = [host]
	}
}