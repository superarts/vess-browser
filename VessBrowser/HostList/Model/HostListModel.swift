import RealmSwift

protocol Host: Storable {
	var name: String { get }
	var address: String { get }
	var favicon: Data { get }
	var created: Date { get }
}

class RealmHost: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var favicon: Data = Data()
	@objc dynamic var created: Date = Date()
}

extension RealmHost: Host {
}
