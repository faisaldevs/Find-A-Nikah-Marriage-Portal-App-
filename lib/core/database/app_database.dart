import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Raw API payloads kept for "cache, then network" reads: one row per
/// cache key, the DTO's `toJson()` encoded as text. Features decode it back
/// through their own DTO, so a backend rename never needs a migration here.
class CachedResponses extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get payload => text()();
  DateTimeColumn get savedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {cacheKey};
}

/// The app's one local database (Drift / SQLite). Holds user content only
/// as a cache, so [clearUserData] wipes it on sign-out.
@DriftDatabase(tables: [CachedResponses])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'find_a_nikah'));

  @override
  int get schemaVersion => 1;

  Future<void> clearUserData() => delete(cachedResponses).go();

  /// Opens the database file (Drift starts its background isolate on the
  /// first query). Called at app start so the first screen that reads the
  /// cache doesn't wait for it.
  Future<void> warmUp() => customSelect('SELECT 1').get();
}
