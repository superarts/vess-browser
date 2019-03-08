import RxCocoa

protocol HostListViewModelProtocol: LifeCycleManagable, HostAccessible {

	var hosts: BehaviorRelay<[Host]> { get }
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
struct HostListViewModel: HostListViewModelProtocol, HostCreatable {
	var hosts = BehaviorRelay<[Host]>(value: [Host]())

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
			hosts.accept(all)
		} else {
			self.loadDefaultHosts()
		}
	}

	private func loadDefaultHosts() {
		/*
		let reddit = hostCreator.reddit
		let youtube = hostCreator.youtube
		*/

		//hosts.value.append(contentsOf: [host, reddit, youtube])
		hosts.accept([hostCreator.blank])
	}
}
