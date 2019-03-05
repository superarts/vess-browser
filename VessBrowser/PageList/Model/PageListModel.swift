import RealmSwift

protocol Page: Storable {
	var name: String { get }
	var address: String { get }
	var host: String { get }
	var created: Date { get }
	var updated: Date { get set }
}

class RealmPage: RealmObject {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	@objc dynamic var host: String = ""
	@objc dynamic var created: Date = Date()
	@objc dynamic var updated: Date = Date()
}

extension RealmPage: Page {
}