import 'dart:convert';

import 'package:find_a_nikah/core/database/app_database.dart';

/// Key → JSON store over [AppDatabase.cachedResponses]. Repositories write
/// only after a successful API response and read it back to show something
/// instantly while the fresh copy loads.
class JsonCache {
  const JsonCache(this._db);

  final AppDatabase _db;

  /// Null when nothing is stored or the stored text no longer decodes.
  Future<Map<String, dynamic>?> read(String key) async {
    final row = await (_db.select(
      _db.cachedResponses,
    )..where((t) => t.cacheKey.equals(key))).getSingleOrNull();
    if (row == null) return null;
    try {
      return jsonDecode(row.payload) as Map<String, dynamic>;
    } on FormatException {
      return null;
    }
  }

  Future<void> write(String key, Map<String, dynamic> json) => _db
      .into(_db.cachedResponses)
      .insertOnConflictUpdate(
        CachedResponsesCompanion.insert(
          cacheKey: key,
          payload: jsonEncode(json),
          savedAt: DateTime.now(),
        ),
      );

  Future<void> clear() => _db.clearUserData();

  Future<void> warmUp() => _db.warmUp();
}
