import RealmSwift

protocol Host: Storable {
	var name: String { get }
	var address: String { get }
	var favicon: Data { get }
	var created: Date { get }
	var updated: Date { get set }
}

class RealmHost: RealmObject {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var favicon: Data = Data()
	@objc dynamic var created: Date = Date()
	@objc dynamic var updated: Date = Date()
}

extension RealmHost: Host {
}