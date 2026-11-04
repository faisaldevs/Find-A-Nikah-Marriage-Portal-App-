/// Default for a nullable `copyWith` parameter, so a call can tell "leave
/// this field as it is" (argument omitted) from "clear it" (explicit
/// `null`):
///
/// ```dart
/// Foo copyWith({Object? bar = unchanged}) => Foo(
///   bar: identical(bar, unchanged) ? this.bar : bar as String?,
/// );
/// ```
const Object unchanged = _Unchanged();

final class _Unchanged {
  const _Unchanged();
}
