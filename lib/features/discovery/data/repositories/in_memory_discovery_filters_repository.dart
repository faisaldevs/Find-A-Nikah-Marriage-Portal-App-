import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/entities/discovery_filters.dart';
import 'package:find_a_nikah/features/discovery/domain/repositories/discovery_filters_repository.dart';

/// Holds the filters for the current session until the discovery API
/// exists. Registered in the `session` DI scope, so sign-out drops it.
class InMemoryDiscoveryFiltersRepository implements DiscoveryFiltersRepository {
  final _controller = StreamController<DiscoveryFilters>.broadcast();
  DiscoveryFilters _current = const DiscoveryFilters();

  @override
  DiscoveryFilters get current => _current;

  @override
  Stream<DiscoveryFilters> watchFilters() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> save(DiscoveryFilters filters) async {
    if (filters != _current) {
      _current = filters;
      _controller.add(filters);
    }
    return right(unit);
  }

  Future<void> dispose() => _controller.close();
}
