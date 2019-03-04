import RealmSwift

protocol Storable {
}

protocol DatabaseAccessorProtocol {
	associatedtype ModelType

	func store(_ obj: Storable)
	func first(filter: String) -> ModelType?
	func all() -> [ModelType]
	func all(filter: String) -> [ModelType]
}

struct RealmDatabaseAccessor<ModelType: RealmSwift.Object>: DatabaseAccessorProtocol {

	private	let realm = try! Realm()

	func store(_ obj: Storable) {
		try! realm.write() {
			realm.add(obj as! RealmSwift.Object)
		}
	}

	func first(filter: String) -> ModelType? {
		return realm.objects(ModelType.self).filter(filter).first
	}

	func all() -> [ModelType] {
		return Array(realm.objects(ModelType.self))
	}

	func all(filter: String) -> [ModelType] {
		return Array(realm.objects(ModelType.self).filter(filter))
	}
}

///
