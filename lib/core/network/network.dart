/// The one Dio setup: interceptors, token refresh and the
/// `DioException` → `ApiException` mapping.
library;

export 'api_client.dart';
export 'api_exception.dart';
export 'dio_exception_mapper.dart'
    show mapDioException, parseRetryAfter, translateDioException;
export 'interceptors/auth_interceptor.dart' show requiresAuthExtraKey;
export 'interceptors/logging_interceptor.dart' show LoggingInterceptor;
export 'interceptors/request_id_interceptor.dart'
    show requestIdExtraKey, requestIdHeader;
export 'interceptors/retry_interceptor.dart' show idempotentExtraKey;
export 'token_store.dart';
