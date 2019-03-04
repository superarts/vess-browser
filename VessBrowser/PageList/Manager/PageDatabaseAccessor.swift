import Foundation

/// Access web page database

protocol PageDatabaseAccessible {
	var pageDatabaseAccessor: RealmDatabaseAccessor<RealmPage> { get }
}

extension PageDatabaseAccessible {
	var pageDatabaseAccessor: RealmDatabaseAccessor<RealmPage> {
		return RealmDatabaseAccessor<RealmPage>()
	}
}
