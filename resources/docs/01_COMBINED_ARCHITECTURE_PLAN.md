# Combined Architecture Plan
## Flutter + Riverpod - Marriage/Dating Portal App
### Best of Both Approaches

---

## Philosophy

**"Pragmatic Production-Ready"**

- Start simple (Your Approach's 2-layer structure)
- Add infrastructure from day 1 (Claude's error handling, logging, caching)
- Design for team growth (Extension points for Domain layer)
- Clear REST + Socket.IO separation (Your strength)
- Testable from start (Claude's testing patterns)

---

## Architecture Layers

```
┌─────────────────────────────────────┐
│        Presentation Layer           │
│  (Pages, Widgets, ViewModels)       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      Domain Layer (Optional)        │
│  (UseCases - add when logic grows)  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Repository Layer (Orchestration)  │
│  (Maps errors, merges data sources) │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Data Sources Layer (Raw data)     │
│  (API, Socket, Local, Cache)        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     Core Layer (Shared Services)    │
│ (Networking, Storage, Logging)      │
└─────────────────────────────────────┘
```

---

## Core Principles

### 1. Unidirectional Data Flow
```
Data Source → Repository → (UseCase) → ViewModel → View
   ↓
Error Handler + Logger
   ↓
Firebase Crashlytics
```

### 2. Explicit Real-Time Handling
```
REST (Dio): Historical data, pagination, mutations
  └─→ Repository.getHistory(id, cursor)
  └─→ ViewModel loads initial data

Socket.IO: Push notifications only
  └─→ Repository.messageStream(id)
  └─→ ViewModel merges into existing list
```

### 3. Error Handling
```
DioException / SocketException
  ↓ (mapped by ErrorHandler)
Failure (NetworkFailure, ServerFailure, etc.)
  ↓ (caught by Repository)
Logged to AppLogger + Firebase Crashlytics
  ↓ (handled by ViewModel)
Display to User + Retry Logic
```

### 4. Caching Strategy
```
API Response
  ↓
Cache to Hive (if successful)
  ↓
Return cached on next failure
  ↓
Auto-sync in background
```

### 5. Feature Isolation
```
core/
  └─ Never imports from features/

features/auth/
  └─ Never imports from features/chat/
  └─ Shares models via core/ if needed

features/chat/
  └─ Can import from core/
  └─ Can't directly import from features/profile/
```

---

## Folder Structure (Complete)

```
lib/
├── main.dart                          # App entry point
├── bootstrap.dart                     # ProviderScope, error handlers setup
│
├── core/
│   │
│   ├── config/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_endpoints.dart
│   │   │   └── hive_keys.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   └── env/
│   │       └── env_config.dart        # API_BASE_URL, etc.
│   │
│   ├── network/
│   │   ├── dio_client.dart            # Dio setup + auth interceptor
│   │   ├── socket_service.dart        # Socket.IO singleton connection
│   │   ├── network_info.dart          # Connectivity checker
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart  # JWT attach + 401 refresh
│   │       ├── error_interceptor.dart # Error logging
│   │       └── logging_interceptor.dart
│   │
│   ├── storage/
│   │   ├── secure_storage_service.dart # flutter_secure_storage wrapper
│   │   ├── hive_service.dart          # Hive initialization + crud
│   │   ├── local_storage.dart         # Abstract interface
│   │   └── hive_boxes/
│   │       ├── auth_box.dart
│   │       ├── user_cache_box.dart
│   │       ├── chat_cache_box.dart
│   │       └── feed_cache_box.dart
│   │
│   ├── error/
│   │   ├── failure.dart               # Failure base class + subclasses
│   │   ├── exception.dart
│   │   └── error_handler.dart         # DioException → Failure mapper
│   │
│   ├── logging/
│   │   ├── app_logger.dart            # Structured logging
│   │   ├── crash_reporter.dart        # Firebase Crashlytics setup
│   │   ├── log_event.dart             # Log model
│   │   └── log_repository.dart        # Send logs to backend (optional)
│   │
│   ├── router/
│   │   ├── app_router.dart            # GoRouter setup
│   │   └── route_guards.dart          # Auth guard, splash guard
│   │
│   ├── utils/
│   │   ├── extensions/
│   │   │   ├── string_extensions.dart
│   │   │   ├── datetime_extensions.dart
│   │   │   └── context_extensions.dart
│   │   ├── helpers/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── geo_helper.dart        # Distance calculation, etc.
│   │   └── mixins/
│   │       └── async_callback_mixin.dart # Handle async callbacks safely
│   │
│   ├── ui/                            # Shared widgets across features
│   │   ├── components/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── custom_loader.dart
│   │   │   └── error_placeholder.dart
│   │   └── dialogs/
│   │       ├── error_dialog.dart
│   │       ├── confirm_dialog.dart
│   │       └── loading_dialog.dart
│   │
│   └── providers/
│       ├── app_providers.dart         # Global providers (DioClient, HiveService)
│       ├── socket_provider.dart       # Socket connection state
│       └── connectivity_provider.dart # Internet connection status
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── auth_response_model.dart
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/                # ADD LATER (not in MVP)
│   │   │       └── login_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── auth_providers.dart  # All auth providers here
│   │       │   └── auth_state.dart     # State models (freezed)
│   │       ├── pages/
│   │       │   ├── splash_page.dart
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           ├── register_form.dart
│   │           └── auth_error_dialog.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── profile_remote_datasource.dart
│   │   │   │   └── profile_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_profile_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_profile_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart
│   │   │   └── usecases/                # ADD LATER
│   │   │       ├── get_profile_usecase.dart
│   │   │       └── update_profile_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── profile_providers.dart
│   │       │   └── profile_state.dart
│   │       ├── pages/
│   │       │   ├── my_profile_page.dart
│   │       │   ├── edit_profile_page.dart
│   │       │   └── user_profile_view_page.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           ├── profile_stats.dart
│   │           └── profile_form.dart
│   │
│   ├── discovery/                      # Find nearby/distant candidates
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── discovery_remote_datasource.dart
│   │   │   │   └── discovery_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── candidate_card_model.dart
│   │   │   │   └── pagination_model.dart
│   │   │   └── repositories/
│   │   │       └── discovery_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── candidate_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── discovery_repository.dart
│   │   │   └── usecases/                # ADD LATER (matching logic)
│   │   │       ├── get_nearby_usecase.dart
│   │   │       ├── like_profile_usecase.dart
│   │   │       └── filter_candidates_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── discovery_providers.dart
│   │       │   └── discovery_state.dart
│   │       ├── pages/
│   │       │   └── discovery_page.dart
│   │       └── widgets/
│   │           ├── candidate_card.dart
│   │           ├── filter_sheet.dart
│   │           └── like_button.dart
│   │
│   ├── feed/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── feed_remote_datasource.dart
│   │   │   │   ├── feed_local_datasource.dart
│   │   │   │   └── feed_socket_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── post_model.dart
│   │   │   │   ├── reaction_model.dart
│   │   │   │   ├── comment_model.dart
│   │   │   │   └── pagination_model.dart
│   │   │   └── repositories/
│   │   │       └── feed_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── post_entity.dart
│   │   │   │   └── reaction_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── feed_repository.dart
│   │   │   └── usecases/                # ADD LATER
│   │   │       ├── get_feed_usecase.dart
│   │   │       └── react_to_post_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── feed_providers.dart
│   │       │   └── feed_state.dart
│   │       ├── pages/
│   │       │   └── feed_page.dart
│   │       └── widgets/
│   │           ├── post_card.dart
│   │           ├── reaction_bar.dart
│   │           ├── comment_section.dart
│   │           └── post_skeleton.dart
│   │
│   ├── chat/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── chat_remote_datasource.dart   # REST history
│   │   │   │   ├── chat_local_datasource.dart    # Hive cache
│   │   │   │   └── chat_socket_datasource.dart   # Socket.IO real-time
│   │   │   ├── models/
│   │   │   │   ├── message_model.dart
│   │   │   │   ├── conversation_model.dart
│   │   │   │   └── typing_status_model.dart
│   │   │   └── repositories/
│   │   │       └── chat_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── message_entity.dart
│   │   │   │   └── conversation_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── chat_repository.dart
│   │   │   └── usecases/                # ADD LATER
│   │   │       ├── send_message_usecase.dart
│   │   │       └── get_chat_history_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── chat_providers.dart
│   │       │   ├── chat_state.dart
│   │       │   └── websocket_provider.dart
│   │       ├── pages/
│   │       │   ├── conversations_page.dart
│   │       │   └── chat_detail_page.dart
│   │       └── widgets/
│   │           ├── message_bubble.dart
│   │           ├── typing_indicator.dart
│   │           ├── message_input.dart
│   │           └── conversation_tile.dart
│   │
│   └── notifications/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── notification_remote_datasource.dart
│       │   │   ├── notification_local_datasource.dart
│       │   │   └── notification_fcm_datasource.dart    # Firebase Messaging
│       │   ├── models/
│       │   │   └── notification_model.dart
│       │   └── repositories/
│       │       └── notification_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── notification_entity.dart
│       │   ├── repositories/
│       │   │   └── notification_repository.dart
│       │   └── usecases/                # ADD LATER
│       │       └── get_notifications_usecase.dart
│       └── presentation/
│           ├── providers/
│           │   ├── notification_providers.dart
│           │   └── notification_state.dart
│           ├── services/
│           │   ├── firebase_notification_service.dart
│           │   └── local_notification_handler.dart
│           └── widgets/
│               └── notification_badge.dart
│
└── test/
    ├── fixtures/
    │   └── mock_data.dart
    ├── features/
    │   ├── auth/
    │   │   ├── domain/
    │   │   │   └── usecases/
    │   │   │       └── login_usecase_test.dart
    │   │   ├── data/
    │   │   │   ├── repositories/
    │   │   │   │   └── auth_repository_impl_test.dart
    │   │   │   └── datasources/
    │   │   │       └── auth_remote_datasource_test.dart
    │   │   └── presentation/
    │   │       ├── providers/
    │   │       │   └── auth_providers_test.dart
    │   │       └── pages/
    │   │           └── login_page_test.dart
    │   └── [similar for other features]
    └── core/
        ├── network/
        │   └── dio_client_test.dart
        ├── logging/
        │   └── app_logger_test.dart
        └── error/
            └── error_handler_test.dart
```

---

## Implementation Timeline

### Phase 1: Foundation (Week 1)
- [ ] Setup Dio + interceptors
- [ ] Setup Hive + boxes
- [ ] Setup Firebase (Crashlytics, FCM)
- [ ] Setup GoRouter
- [ ] Error handling infrastructure
- [ ] Logging infrastructure
- [ ] Core providers (socket, connectivity)

### Phase 2: Auth (Week 1-2)
- [ ] Login/Register flow
- [ ] Token storage (secure + Hive cache)
- [ ] Token refresh on 401
- [ ] Route guards
- [ ] Auth error handling

### Phase 3: Core Features (Week 2-4)
- [ ] Profile (view + edit)
- [ ] Discovery (geo-location, pagination)
- [ ] Feed (REST + Socket.IO real-time)
- [ ] Chat (REST history + Socket.IO messages)

### Phase 4: Polish (Week 5-6)
- [ ] Unit tests for repositories
- [ ] Widget tests for critical screens
- [ ] Error handling edge cases
- [ ] Hive caching strategy
- [ ] Firebase Analytics (optional)

---

## Provider Naming Convention

```dart
// Repository providers (all at presentation/providers)
final [featureName]RepositoryProvider = Provider<[Feature]Repository>((ref) => ...);

// Async data providers (list)
final [featureName]sProvider = FutureProvider<List<[Entity]>>((ref) => ...);

// Async data providers (single, with parameter)
final [featureName]ByIdProvider = FutureProvider.family<[Entity], String>((ref, id) => ...);

// Real-time stream providers
final [featureName]sStreamProvider = StreamProvider<[Entity]>((ref) => ...);
final [featureName]StreamProvider = StreamProvider.family<[Entity], String>((ref, id) => ...);

// State notifier (complex state with mutations)
final [featureName]StateProvider = StateNotifierProvider<[Feature]Notifier, [Feature]State>((ref) => ...);

// Simple state (toggle, counter)
final [featureName]Provider = StateProvider<[Type]>((ref) => ...);

// Example:
final messagesProvider = FutureProvider.family<List<MessageEntity>, String>((ref, conversationId) => ...);
final messagesStreamProvider = StreamProvider.family<MessageEntity, String>((ref, conversationId) => ...);
final chatFormStateProvider = StateNotifierProvider<ChatFormNotifier, ChatFormState>((ref) => ...);
```

---

## Error Handling Flow (Concrete Example)

```dart
// 1. DioException or SocketException thrown
// ↓
try {
  final response = await dioClient.get('/chat/messages/$id');
  return response.data;
} catch (e) {
  // 2. Catch in DataSource, rethrow
  rethrow;
}

// ↓ bubbles up to Repository
try {
  final remoteMessages = await remoteDataSource.getMessages(id);
  await localDataSource.cacheMessages(remoteMessages);
  return remoteMessages;
} catch (e) {
  // 3. Map exception to Failure
  final failure = ErrorHandler.mapExceptionToFailure(e);
  
  // 4. Log the error
  await AppLogger().logError(
    'Failed to fetch messages',
    error: e,
    stackTrace: stackTrace,
    tag: 'ChatRepository',
  );
  
  // 5. Try fallback to cache
  try {
    return await localDataSource.getCachedMessages(id);
  } catch (_) {
    throw failure; // Cache also empty, propagate error
  }
}

// ↓ bubbles up to ViewModel/Provider
@riverpod
class ChatViewModel extends _$ChatViewModel {
  Future<ChatState> build() async {
    try {
      final messages = await chatRepository.getMessages(conversationId);
      return ChatState(messages: messages, error: null);
    } on NetworkFailure {
      // Retry with exponential backoff, or show "offline" UI
      return ChatState(messages: [], error: 'Offline mode');
    } on ServerFailure catch (e) {
      // Log to backend, show friendly message
      return ChatState(messages: [], error: 'Server error: ${e.message}');
    } on UnauthorizedFailure {
      // Auto-logout
      ref.read(authProvider.notifier).logout();
      rethrow;
    }
  }
}

// ↓ UI consumes state
Widget build(context, ref) {
  final chatState = ref.watch(chatViewModelProvider);
  return chatState.when(
    data: (state) => state.error != null 
      ? ErrorWidget(error: state.error) 
      : ChatList(messages: state.messages),
    loading: () => ChatSkeleton(),
    error: (err, stack) => ErrorWidget(error: err),
  );
}
```

---

## Caching Strategy

### When to Cache

**Cache (Hive) on successful API response:**
```dart
final messages = await remoteDataSource.getMessages(id);
await localDataSource.cacheMessages(id, messages);  // ← Save it
return messages;
```

**Return cache on API failure:**
```dart
try {
  return await remoteDataSource.getMessages(id);
} catch (e) {
  return await localDataSource.getCachedMessages(id); // ← Fallback
}
```

### What to Cache

| Data | Cache? | Why |
|---|---|---|
| Auth tokens | ✅ Yes (secure_storage) | Need across sessions |
| User profile | ✅ Yes (Hive) | Show instantly on reopen |
| Chat messages | ✅ Yes (Hive) | Read old messages offline |
| Feed posts | ✅ Yes (Hive) | Resume scroll position |
| Candidate cards | ✅ Yes (Hive) | Reshow swiped candidates |
| Reactions/Likes | ⚠️ Maybe (invalidate after 1h) | Can get stale quickly |
| Comments | ⚠️ Maybe (invalidate after 1h) | Growing data, moderate cache |

### Cache Invalidation Strategy

```dart
// Option 1: Time-based (for data that changes frequently)
final cachedFor = DateTime.now().difference(lastFetchedAt).inMinutes;
if (cachedFor > 30) {
  await localDataSource.clearCache(); // Invalidate after 30 min
}

// Option 2: Manual (when user pulls to refresh)
Future<void> refresh() async {
  await localDataSource.clearCache();
  final fresh = await remoteDataSource.getMessages(id);
  return fresh;
}

// Option 3: Event-based (when related action happens)
// After sending message, invalidate conversation cache
await sendMessage(msg);
await localDataSource.clearConversationCache(conversationId);
```

---

## Real-Time Flow (Chat Example)

```
┌─ User sends message
│
├─→ ViewModel.sendMessage(text)
│    └─→ Repository.sendMessage(Message)
│         ├─→ RemoteDataSource.POST /messages (REST)
│         │    └─→ Returns Message with ID + timestamp
│         └─→ LocalDataSource.addMessageToCache (Hive)
│              └─→ Optimistic UI update
│
└─ Message arrives from Socket.IO
   ├─→ ChatSocketDataSource.on('receive_message')
   │    └─→ emits Stream<Message>
   ├─→ Repository.messageStream (wraps socket stream)
   │    └─→ LocalDataSource.addMessageToCache (Hive)
   │         └─→ Merges into existing conversation list
   └─→ ViewModel merges into state.messages
        └─→ UI shows new message
```

**Key:** User sees message immediately (optimistic update via REST), then real-time confirmation via Socket (if arrives, or retries if fails).

---

## REST vs Socket Usage

| Operation | Channel | Why |
|---|---|---|
| Get message history | REST | Paginated, historical, cacheable |
| Send message | REST | Needs confirmation + server ID |
| Receive message | Socket.IO | Push notification, real-time |
| Get current user | REST | Once per session, cache it |
| Live typing indicator | Socket.IO | Ephemeral, push-only |
| Like post | REST | Mutation, needs confirmation |
| See new post in feed | Socket.IO | Notification channel only |
| Get post comments | REST (lazy) | Loaded when post expanded |

---

## Feature Boundaries

### auth/ is responsible for:
- Login, register, logout
- Token management
- Auth state (loggedIn, loggedOut, loading)
- **Not responsible:** Password validation (that's domain layer later)

### profile/ is responsible for:
- Fetching user profile
- Editing profile
- Uploading photos
- **Not responsible:** Profile filtering (discovery/ does that)

### discovery/ is responsible for:
- Fetching nearby candidates
- Pagination + cursor management
- Filtering by age, location, etc.
- Like/pass actions
- **Not responsible:** User profile data (profile/ owns that)

### feed/ is responsible for:
- Fetching posts (paginated REST)
- Displaying live post updates (Socket.IO)
- Reactions + comments (lazy load)
- **Not responsible:** Post creation (separate feature later)

### chat/ is responsible for:
- Chat history (REST, paginated)
- Sending messages (REST)
- Receiving messages (Socket.IO)
- Typing indicators (Socket.IO)
- **Not responsible:** User profile lookup (profile/ owns that)

### notifications/ is responsible for:
- Local notification display
- Firebase Cloud Messaging handling
- Notification badge count
- **Not responsible:** Actual message sending (chat/ does that)

---

## Testing Strategy

### Unit Tests (Test Business Logic)
```dart
// test/features/chat/data/repositories/chat_repository_impl_test.dart
// Test: Repository correctly merges cache + remote + error handling

test('returns cached messages on network error', () async {
  when(() => remoteDataSource.getMessages(id))
    .thenThrow(NetworkFailure());
  
  when(() => localDataSource.getCachedMessages(id))
    .thenAnswer((_) async => [mockMessage1, mockMessage2]);
  
  final result = await repository.getMessages(id);
  expect(result, [mockMessage1, mockMessage2]);
});
```

### Provider Tests (Test State Management)
```dart
// test/features/chat/presentation/providers/chat_providers_test.dart
// Test: Provider correctly updates state on data/error

test('chatViewModelProvider emits loading then data', () async {
  final container = ProviderContainer();
  final provider = chatViewModelProvider('conv_123');
  
  final result = container.read(provider);
  await expectLater(
    container.read(provider.future),
    completion(isA<ChatState>()),
  );
});
```

### Widget Tests (Test UI)
```dart
// test/features/chat/presentation/pages/chat_detail_page_test.dart
// Test: Page correctly displays messages and handles user interactions

testWidgets('sends message on send button tap', (tester) async {
  await tester.pumpWidget(ProviderScope(child: ChatDetailPage(...)));
  
  await tester.enterText(find.byType(TextField), 'Hello');
  await tester.tap(find.byIcon(Icons.send));
  await tester.pumpAndSettle();
  
  expect(find.text('Hello'), findsOneWidget);
});
```

---

## Dependency Injection

All dependencies flow through Riverpod providers in `presentation/providers/` or `core/providers/`:

```dart
// ✅ Correct: Through providers
final repository = ref.watch(chatRepositoryProvider);

// ❌ Wrong: Direct instantiation
final repository = ChatRepositoryImpl(dio, hive);

// ✅ Correct: Testable (can override provider in tests)
container.override(chatRepositoryProvider, FakeRepository());

// ❌ Wrong: Hard to test
// Can't mock ChatRepositoryImpl if it's created directly
```

---

## Development Workflow

1. **Define entity** (`domain/entities/`)
2. **Define repository interface** (`domain/repositories/`)
3. **Create model** (`data/models/` - extends entity, adds JSON)
4. **Create datasources** (`data/datasources/` - remote, local)
5. **Implement repository** (`data/repositories/` - orchestrate datasources)
6. **Create providers** (`presentation/providers/` - dependency + state)
7. **Build UI** (`presentation/pages/` + `widgets/`)
8. **Add tests** (mirror the above in `test/` folder)
9. **Refactor to UseCase** (only when logic gets complex/repeated)

---

## Migration Path (When to Add Domain Layer)

Add a UseCase when:
1. **Same logic appears in 2+ ViewModels** - Extract to UseCase
2. **ViewModel logic is >50 lines** - Probably needs a UseCase
3. **Business logic independent of UI state** - Should be in UseCase

**Example:** Both discovery/ and feed/ need to filter candidates by age. Create:
```dart
// core/domain/usecases/filter_by_age_usecase.dart
class FilterByAgeUseCase {
  List<CandidateEntity> call(List<CandidateEntity> candidates, int minAge, int maxAge) {
    return candidates.where((c) => c.age >= minAge && c.age <= maxAge).toList();
  }
}

// Then both can use it:
// discovery_view_model.dart
final filtered = await ref.read(filterByAgeUseCaseProvider)(candidates, 20, 30);

// feed_view_model.dart
final filtered = await ref.read(filterByAgeUseCaseProvider)(candidates, 20, 30);
```

---

## Gotchas & Best Practices

### 1. Never Call DataSource Directly from ViewModel
```dart
// ❌ Wrong
final messages = await dioClient.get('/messages');

// ✅ Correct
final messages = await repository.getMessages();
```

### 2. Never Store UI State in Repository
```dart
// ❌ Wrong - this is ViewModel state
repository.isLoading = true;

// ✅ Correct - ViewModel manages this
state = AsyncValue.loading();
```

### 3. Always Cache After Successful API Call
```dart
// ❌ Wrong
final data = await remoteDataSource.getData();
return data;

// ✅ Correct
final data = await remoteDataSource.getData();
await localDataSource.cacheData(data); // Save for offline
return data;
```

### 4. Socket.IO Should Never Directly Update ViewModel State
```dart
// ❌ Wrong - socket reaches into state
socket.on('message', (data) {
  viewModelState.messages.add(Message.fromJson(data));
});

// ✅ Correct - socket emits to stream, ViewModel listens
final messageStream = repository.messageStream(id);
messageStream.listen((msg) {
  state = AsyncData(state.value!.copyWith(messages: [msg, ...state.value!.messages]));
});
```

### 5. Use `ref.read()` vs `ref.watch()`
```dart
// ✅ watch - rebuilds when dependency changes
final user = ref.watch(currentUserProvider);

// ✅ read - get current value once (inside method)
Future<void> deletePost() async {
  final repo = ref.read(postRepositoryProvider);
  await repo.deletePost(postId);
}

// ❌ Wrong - don't watch inside functions
Future<void> deletePost() async {
  final repo = ref.watch(postRepositoryProvider); // ← causes rebuild
  await repo.deletePost(postId);
}
```

### 6. Use `select()` to Prevent Unnecessary Rebuilds
```dart
// ❌ Rebuilds when ANY field changes
final user = ref.watch(currentUserProvider);

// ✅ Only rebuilds when name changes
final userName = ref.watch(currentUserProvider.select((userAsync) {
  return userAsync.whenData((user) => user.name);
}));
```

### 7. Always Set Timeout on Dio Requests
```dart
// Dio client
Dio(BaseOptions(
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 30),
))
```

### 8. Use `keepAlive` for Long-Lived Providers
```dart
// Socket connection should stay alive
@riverpod
class SocketProvider extends _$SocketProvider {
  @override
  build() {
    ref.onDispose(() => socket.disconnect());
    return socket.connect();
  }
}
```

---

## Production Checklist

- [ ] Error handling covers all failure types (Network, Server, Validation, Unauthorized)
- [ ] Logging configured (AppLogger + Firebase Crashlytics)
- [ ] Hive caching for: tokens, profile, messages, feed
- [ ] Secure token storage (flutter_secure_storage)
- [ ] Auth interceptor handles 401 + token refresh
- [ ] Route guards prevent unauthorized navigation
- [ ] Socket.IO reconnection logic (exponential backoff)
- [ ] Image caching (cached_network_image)
- [ ] Pagination implemented (cursor-based, not offset)
- [ ] Tests pass (unit + widget)
- [ ] Analytics tracking setup
- [ ] Crash reporting enabled

---

## Key File Templates (Generate These First)

1. **core/error/failure.dart** - All failure types
2. **core/logging/app_logger.dart** - Logging infrastructure
3. **core/network/dio_client.dart** - Dio + interceptors
4. **core/network/socket_service.dart** - Socket.IO singleton
5. **core/storage/hive_service.dart** - Hive boxes
6. **core/router/app_router.dart** - GoRouter setup
7. **bootstrap.dart** - App initialization

Once these 7 files exist, adding new features is mechanical (follow the template in each feature folder).
