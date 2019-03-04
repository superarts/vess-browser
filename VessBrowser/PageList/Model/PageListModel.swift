import RealmSwift

protocol Page: Storable {
	var name: String { get }
	var address: String { get }
	var host: String { get }
	var created: Date { get }
}

class RealmPage: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var host: String = ""
	@objc dynamic var created: Date = Date()
}

extension RealmPage: Page {
}
