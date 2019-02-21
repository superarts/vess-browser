import RealmSwift

class Website: Object {
	@objc dynamic var name: String = ""
	@objc dynamic var address: String = ""
	/*
	required init(name: String, address: String) {
		super.init()
		self.name = name
		self.address = address
	}
	*/
}

protocol DataStorable {
	var databaseInstance: Database { get }
}

extension DataStorable {
	var databaseInstance: Database {
		return Database()
	}
}

struct Database {
	func write(_ obj: Object) {
		let realm = try! Realm()
		try! realm.write() {
			realm.add(obj)
		}
	}
}