# Quick Reference & Implementation Checklist
## Copy This When Starting Each Feature

---

## Feature Implementation Checklist

Use this when building a new feature. Check off as you go.

### Phase 1: Domain Layer Setup

```
Feature Name: ____________

□ Create domain/entities/
  └─ [ ] Entity class (data model, pure Dart)

□ Create domain/repositories/
  └─ [ ] Abstract Repository interface
  └─ [ ] Define all methods needed

□ Create domain/usecases/ (OPTIONAL - add later if needed)
  └─ [ ] UseCase class (wraps repository, adds business logic)
```

**Example (Chat Feature):**
```dart
// domain/entities/message_entity.dart
class MessageEntity {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;
  
  MessageEntity({...});
}

// domain/repositories/chat_repository.dart
abstract class ChatRepository {
  Future<List<MessageEntity>> getMessages(String conversationId);
  Future<void> sendMessage(MessageEntity message);
  Stream<MessageEntity> listenToMessages(String conversationId);
}
```

---

### Phase 2: Data Layer Setup

```
□ Create data/models/
  └─ [ ] Model class (extends Entity, JSON serializable)
  └─ [ ] fromJson() factory
  └─ [ ] toJson() method

□ Create data/datasources/
  └─ [ ] Remote datasource (API calls)
  └─ [ ] Local datasource (Hive cache)

□ Create data/repositories/
  └─ [ ] Repository implementation (orchestrates datasources)
  └─ [ ] Error handling (try-catch + ErrorHandler)
  └─ [ ] Caching logic (save after success, return cache on fail)
```

**Datasource Contract:**
```dart
// Remote = pure API calls (no error handling)
abstract class ChatRemoteDataSource {
  Future<List<MessageModel>> getMessages(String conversationId);
}

// Local = pure cache/storage calls (no error handling)
abstract class ChatLocalDataSource {
  Future<void> cacheMessages(String conversationId, List<MessageModel> messages);
  Future<List<MessageModel>?> getCachedMessages(String conversationId);
}

// Repository = orchestrates both + handles errors
class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<List<MessageEntity>> getMessages(String conversationId) async {
    try {
      final messages = await remoteDataSource.getMessages(conversationId);
      await localDataSource.cacheMessages(conversationId, messages);
      return messages;
    } catch (e, stack) {
      await AppLogger().logError('fetch messages', error: e, stackTrace: stack);
      return await localDataSource.getCachedMessages(conversationId);
    }
  }
}
```

---

### Phase 3: Presentation Layer Setup

```
□ Create presentation/providers/
  └─ [ ] [Feature]Providers (all dependency injection)
  └─ [ ] [Feature]State (state models, using Freezed)
  └─ [ ] Data providers (FutureProvider, StreamProvider)
  └─ [ ] View model provider (StateNotifierProvider)

□ Create presentation/pages/
  └─ [ ] Main page (ConsumerWidget)
  └─ [ ] Watch providers, handle AsyncValue.when()

□ Create presentation/widgets/
  └─ [ ] Reusable components for this feature
  └─ [ ] Each widget takes data + callbacks
```

**Provider Template:**
```dart
// presentation/providers/chat_providers.dart

// 1. Dependency injection
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  return ChatLocalDataSourceImpl(ref.watch(hiveServiceProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDataSourceProvider),
    ref.watch(chatLocalDataSourceProvider),
  );
});

// 2. Data providers
final messagesProvider = FutureProvider.family<List<MessageEntity>, String>((ref, conversationId) {
  return ref.watch(chatRepositoryProvider).getMessages(conversationId);
});

final messagesStreamProvider = StreamProvider.family<MessageEntity, String>((ref, conversationId) {
  return ref.watch(chatRepositoryProvider).listenToMessages(conversationId);
});

// 3. State models
@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    required List<MessageEntity> messages,
    required bool isLoading,
    @Default(null) String? error,
  }) = _ChatState;
}

// 4. View model (if needed for complex state)
final chatViewModelProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref.watch(chatRepositoryProvider));
});

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository repository;
  
  ChatNotifier(this.repository) : super(ChatState(...));
  
  Future<void> sendMessage(String text) async {
    state = state.copyWith(isLoading: true);
    try {
      await repository.sendMessage(...);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

**Page Template:**
```dart
// presentation/pages/chat_page.dart

class ChatPage extends ConsumerWidget {
  final String conversationId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider(conversationId));
    
    return messagesAsync.when(
      data: (messages) => ChatView(messages: messages),
      loading: () => ChatSkeleton(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}

class ChatView extends ConsumerWidget {
  final List<MessageEntity> messages;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(message: messages[index]);
            },
          ),
        ),
        MessageInput(onSend: (text) {
          ref.read(chatViewModelProvider.notifier).sendMessage(text);
        }),
      ],
    );
  }
}
```

---

### Phase 4: Testing

```
□ Unit tests (data layer)
  └─ [ ] Repository tests (mocking datasources)
  └─ [ ] DataSource tests (mocking Dio/Hive)

□ Provider tests (state management)
  └─ [ ] Provider returns correct state
  └─ [ ] Provider handles errors correctly
  └─ [ ] Provider.refresh() works

□ Widget tests (UI)
  └─ [ ] Page renders correctly
  └─ [ ] User interactions work
  └─ [ ] Error states display correctly
```

**Repository Test Template:**
```dart
void main() {
  group('ChatRepository', () {
    late ChatRepository repository;
    late MockChatRemoteDataSource mockRemote;
    late MockChatLocalDataSource mockLocal;
    
    setUp(() {
      mockRemote = MockChatRemoteDataSource();
      mockLocal = MockChatLocalDataSource();
      repository = ChatRepositoryImpl(mockRemote, mockLocal);
    });
    
    test('returns remote data and caches it', () async {
      when(() => mockRemote.getMessages('conv_1'))
        .thenAnswer((_) async => [mockMessage1, mockMessage2]);
      
      final result = await repository.getMessages('conv_1');
      
      expect(result, [mockMessage1, mockMessage2]);
      verify(() => mockLocal.cacheMessages('conv_1', [mockMessage1, mockMessage2])).called(1);
    });
    
    test('returns cached data on remote error', () async {
      when(() => mockRemote.getMessages('conv_1'))
        .thenThrow(NetworkFailure());
      
      when(() => mockLocal.getCachedMessages('conv_1'))
        .thenAnswer((_) async => [mockMessage1]);
      
      final result = await repository.getMessages('conv_1');
      
      expect(result, [mockMessage1]);
    });
  });
}
```

---

## Code Snippets (Copy & Paste)

### Error Handling in Repository
```dart
try {
  final result = await remoteDataSource.fetchData();
  await localDataSource.cacheData(result);
  return result;
} catch (e, stack) {
  await AppLogger().logError('Fetch failed', error: e, stackTrace: stack);
  
  try {
    return await localDataSource.getCachedData();
  } catch (_) {
    throw ErrorHandler.mapExceptionToFailure(e);
  }
}
```

### Pagination in Provider
```dart
@riverpod
class FeedViewModel extends _$FeedViewModel {
  @override
  Future<FeedState> build() async {
    final repo = ref.watch(feedRepositoryProvider);
    final page = await repo.getPosts(cursor: null);
    return FeedState(posts: page.items, nextCursor: page.nextCursor);
  }
  
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current?.nextCursor == null) return;
    
    state = AsyncData(current!.copyWith(isLoading: true));
    try {
      final repo = ref.read(feedRepositoryProvider);
      final page = await repo.getPosts(cursor: current.nextCursor);
      
      state = AsyncData(current.copyWith(
        posts: [...current.posts, ...page.items],
        nextCursor: page.nextCursor,
        isLoading: false,
      ));
    } catch (e) {
      state = AsyncData(current.copyWith(isLoading: false));
    }
  }
}
```

### Real-Time Stream Merge
```dart
final messagesProvider = StreamProvider.family<MessageEntity, String>((ref, conversationId) {
  return ref.watch(chatRepositoryProvider)
    .listenToMessages(conversationId);
});

// In ViewModel, merge history + stream
@riverpod
class ChatViewModel extends _$ChatViewModel {
  Future<ChatState> build(String conversationId) async {
    // Load history
    final history = await repository.getMessages(conversationId);
    return ChatState(messages: history);
  }
  
  void listenToUpdates(String conversationId) {
    repository.listenToMessages(conversationId).listen((newMessage) {
      state = AsyncData(state.value!.copyWith(
        messages: [newMessage, ...state.value!.messages],
      ));
    });
  }
}
```

### Hive Caching
```dart
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final HiveService hiveService;
  
  @override
  Future<void> cacheMessages(String conversationId, List<MessageModel> messages) async {
    final box = await Hive.openBox('chat_messages');
    await box.put(conversationId, messages);
  }
  
  @override
  Future<List<MessageModel>?> getCachedMessages(String conversationId) async {
    final box = await Hive.openBox('chat_messages');
    return box.get(conversationId);
  }
}
```

---

## Common Mistakes to Avoid

### ❌ Don't Do This

```dart
// ❌ Call DataSource directly from ViewModel
final messages = await dioClient.get('/messages');

// ❌ Store UI state in Repository
repository.isLoading = true;

// ❌ Don't cache without checking success
await localDataSource.cacheData(data);
return data; // Might be error, shouldn't cache

// ❌ Don't call async inside watch
final data = ref.watch(provider); // OK
// ...
final moreData = await something(); // ❌ NO! Use read()

// ❌ Don't skip error handling
try {
  return await repository.getData();
} // ❌ What if error?

// ❌ Don't access state directly outside notifier
repository.messageCount = 0; // ❌ Repositories shouldn't have mutable state

// ❌ Don't import across features directly
import 'features/chat/data/models/message_model.dart'; // ❌
// Import through core/models/ instead

// ❌ Don't use watch for one-time fetches
ref.watch(dataProvider); // Rebuilds on every change
// Use ref.read() in callbacks instead
```

---

### ✅ Do This Instead

```dart
// ✅ Go through Repository
final messages = await repository.getMessages(id);

// ✅ Keep state in ViewModel/Provider
state = state.copyWith(isLoading: true);

// ✅ Cache after confirmed success
try {
  final data = await remoteDataSource.getData();
  await localDataSource.cacheData(data); // Only if success
  return data;
} catch (e) {
  // Fallback to cache
}

// ✅ Use read for one-time operations
Future<void> onSendMessage(String text) async {
  final repo = ref.read(repositoryProvider);
  await repo.sendMessage(text);
}

// ✅ Always log errors
} catch (e, stack) {
  await AppLogger().logError('Action failed', error: e, stackTrace: stack);
  throw ErrorHandler.mapExceptionToFailure(e);
}

// ✅ Repository has immutable data
@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({...}) = _MessageEntity;
}

// ✅ Share models through core
import 'core/models/shared_models.dart';

// ✅ Use select to prevent rebuilds
ref.watch(userProvider.select((userAsync) => userAsync.whenData((u) => u.name)));
```

---

## File Naming Convention

```
Feature Name: Profile

✅ Correct:
- profile_repository.dart
- profile_remote_datasource.dart
- profile_local_datasource.dart
- profile_entity.dart
- profile_model.dart
- profile_providers.dart
- profile_page.dart
- profile_form.dart
- profile_repository_impl.dart
- profile_state.dart
- profile_view_model.dart

❌ Wrong:
- repository.dart (ambiguous)
- profile_impl.dart (redundant)
- profile_screen.dart (use _page.dart)
- profile_widget.dart (use _page.dart or component name)
- profileRepository.dart (use snake_case)
```

---

## Provider Override for Testing

```dart
// In tests, override providers to use mocks

final container = ProviderContainer(
  overrides: [
    chatRepositoryProvider.overrideWithValue(MockChatRepository()),
    dioClientProvider.overrideWithValue(MockDioClient()),
  ],
);

// Now when code uses chatRepositoryProvider, it gets the mock
final repo = container.read(chatRepositoryProvider);
expect(repo, isA<MockChatRepository>());
```

---

## Feature Folder Structure

Create this for each feature:

```
features/[feature_name]/
├── data/
│   ├── datasources/
│   │   ├── [feature]_remote_datasource.dart
│   │   ├── [feature]_remote_datasource_impl.dart
│   │   ├── [feature]_local_datasource.dart
│   │   └── [feature]_local_datasource_impl.dart
│   ├── models/
│   │   └── [feature]_model.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [feature]_entity.dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   └── usecases/ (ADD LATER)
│       └── [usecase]_usecase.dart
└── presentation/
    ├── providers/
    │   ├── [feature]_providers.dart
    │   └── [feature]_state.dart
    ├── pages/
    │   └── [feature]_page.dart
    └── widgets/
        ├── [feature]_[component].dart
        └── [component].dart
```

---

## Quick Debug Checklist

When something doesn't work:

```
□ Error in API call?
  → Check Dio interceptors
  → Check API endpoint
  → Check request body format
  → Check response in network tab

□ State not updating?
  → Check if using watch() or read()
  → Check if StateNotifier.state = is being used
  → Check if copyWith() is creating new object
  → Verify provider is being watched

□ Cache not working?
  → Check if Hive box is initialized
  → Check if caching happens after success
  → Check if cache fallback is in try-catch
  → Verify box name in Hive vs code

□ Widget not rebuilding?
  → Check if using ConsumerWidget
  → Check if watching provider (not reading)
  → Check if model is Freezed (immutable)
  → Use .select() if watching large object

□ Socket events not received?
  → Check Socket connection status
  → Check event name matches backend
  → Check Socket initialization
  → Check if connected before listening
  → Check browser console for Socket errors
```

---

## How to Report Bugs (For AI Assistant)

When asking Claude to help debug:

```
Problem: [Brief description]

Code snippet:
[Paste relevant code]

What I expected:
[What should happen]

What actually happened:
[What's happening instead]

Error message:
[Full error if any]

Steps to reproduce:
1. ...
2. ...
3. ...

Have you tried:
□ Flutter clean
□ pub get
□ Restart emulator
□ Print debugging
```

---

## Key Commands

```bash
# Create new feature boilerplate (manual, but keep this checklist)
flutter pub run build_runner build      # Generate freezed + json

# Test
flutter test                             # Run all tests
flutter test test/features/auth/        # Run feature tests only

# Clean
flutter clean                            # Full rebuild
flutter pub clean                        # Clear pub cache

# Debug
flutter run -v                           # Verbose logging
flutter run --profile                    # Profile mode (for performance)

# Logs
flutter logs                             # Real-time device logs
flutter logs | grep "YOUR_TAG"           # Filter logs
```

---

## When to Use What

| Situation | Use |
|---|---|
| Simple state (toggle, counter) | `StateProvider` |
| Loading async data (one-time) | `FutureProvider` |
| Real-time data (WebSocket, Stream) | `StreamProvider` |
| Complex state (form, multiple methods) | `StateNotifierProvider` |
| Get provider value once in callback | `ref.read()` |
| Watch provider, rebuild on change | `ref.watch()` |
| Need specific field only | `ref.watch(...).select(...)` |
| Catch specific error type | `try { } on SpecificFailure { }` |
| Generic error catch | `catch (e)` then `ErrorHandler.map()` |
| One-time API call with retry | Make it a method on repository, call via `ref.read()` |
| Need to invalidate cache | `ref.invalidate(provider)` or `ref.refresh(provider)` |

---

## Save Time With These Templates

Create these files once, copy for each feature:

```dart
// Template: [feature]_remote_datasource.dart
abstract class [Feature]RemoteDataSource {
  Future<[Model]> [method](/* params */);
}

class [Feature]RemoteDataSourceImpl implements [Feature]RemoteDataSource {
  final DioClient dioClient;
  
  [Feature]RemoteDataSourceImpl({required this.dioClient});
  
  @override
  Future<[Model]> [method](/* params */) async {
    try {
      final response = await dioClient.get('/endpoint');
      return [Model].fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
```

---

## Before Committing Code

- [ ] Run `flutter analyze` (no errors/warnings)
- [ ] Run `flutter format .` (code formatted)
- [ ] Run `flutter test` (tests pass)
- [ ] Tested on device/emulator
- [ ] No debug prints or TODO comments
- [ ] No commented-out code
- [ ] Added meaningful commit message
- [ ] Checked that imports are correct (no unused)

---

## Feature-Specific Implementation Patterns

### Auth Feature Pattern

**Special Considerations:**
- Token refresh on 401
- Persistent login (read from secure storage on app start)
- Route guard (redirect to login if not authenticated)

**Flow:**
```
1. User enters email + password
2. LoginForm.onPressed() → ViewModel.login()
3. ViewModel → Repository.login()
4. Repository → RemoteDataSource.POST /auth/login
5. Response: { accessToken, refreshToken, user }
6. Save tokens to flutter_secure_storage
7. Save user to Hive cache
8. Emit success state
9. Route guard sees user is authenticated
10. Redirect to home page

On 401 (token expired):
1. Interceptor detects 401
2. Calls Repository.refreshToken()
3. Gets new accessToken from backend
4. Saves to flutter_secure_storage
5. Retries original request with new token
```

**Key Repository Code:**
```dart
Future<UserEntity> login(String email, String password) async {
  try {
    final response = await remoteDataSource.login(email, password);
    
    // Save tokens (secure)
    await secureStorage.saveAccessToken(response.accessToken);
    await secureStorage.saveRefreshToken(response.refreshToken);
    
    // Cache user (local)
    await localDataSource.cacheUser(response.user);
    
    return response.user;
  } catch (e) {
    throw ErrorHandler.mapExceptionToFailure(e);
  }
}

Future<String> refreshToken() async {
  try {
    final refreshToken = await secureStorage.getRefreshToken();
    final response = await remoteDataSource.refreshToken(refreshToken);
    
    // Update stored token
    await secureStorage.saveAccessToken(response.accessToken);
    
    return response.accessToken;
  } catch (e) {
    // Refresh failed = logout user
    await logout();
    throw UnauthorizedFailure();
  }
}

Future<void> logout() async {
  await secureStorage.clearTokens();
  await localDataSource.clearUserCache();
}
```

---

### Chat Feature Pattern

**Special Considerations:**
- REST for history (paginated)
- Socket.IO for real-time messages
- Merging both data sources
- Optimistic updates

**Flow:**
```
Initial Load:
1. Page opens → Provider loads messages via REST
2. Repository.getMessages(conversationId, cursor: null)
3. Shows cached or loading state
4. Renders messages with pagination

Real-Time Updates:
1. Socket.IO emits 'receive_message'
2. Repository.messageStream() emits Message
3. ViewModel merges into state.messages
4. UI rebuilds with new message

Send Message:
1. User types and taps send
2. ViewModel.sendMessage(text)
3. Create optimistic Message (temp ID)
4. Add to messages immediately (UI shows instantly)
5. Call Repository.sendMessage() in background
6. On success: replace temp with real message (real ID)
7. On failure: mark as failed, show retry button
```

**Key Provider Code:**
```dart
// Load initial messages (REST + cache)
final messagesProvider = FutureProvider.family<List<MessageEntity>, String>(
  (ref, conversationId) {
    final repo = ref.watch(chatRepositoryProvider);
    return repo.getMessages(conversationId, cursor: null);
  },
);

// Listen to real-time updates (Socket.IO)
final messagesStreamProvider = StreamProvider.family<MessageEntity, String>(
  (ref, conversationId) {
    final repo = ref.watch(chatRepositoryProvider);
    return repo.listenToMessages(conversationId);
  },
);

// Complex state management
@freezed
class ChatPageState with _$ChatPageState {
  const factory ChatPageState({
    required List<MessageEntity> messages,
    String? nextCursor,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(null) String? error,
  }) = _ChatPageState;
}

@riverpod
class ChatPageNotifier extends _$ChatPageNotifier {
  Future<ChatPageState> build(String conversationId) async {
    // Load initial messages
    final messages = await ref.watch(chatRepositoryProvider)
        .getMessages(conversationId, cursor: null);
    
    return ChatPageState(messages: messages);
  }
  
  // Load older messages (pagination)
  Future<void> loadMore(String conversationId) async {
    final current = state.valueOrNull;
    if (current?.nextCursor == null) return;
    
    state = AsyncData(current!.copyWith(isLoadingMore: true));
    
    try {
      final repo = ref.read(chatRepositoryProvider);
      final page = await repo.getMessages(
        conversationId,
        cursor: current.nextCursor,
      );
      
      state = AsyncData(current.copyWith(
        messages: [...current.messages, ...page.items],
        nextCursor: page.nextCursor,
        isLoadingMore: false,
      ));
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
  
  // Send message (optimistic update)
  Future<void> sendMessage(String conversationId, String text) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    // Create temporary message
    final tempMessage = MessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: currentUserId,
      text: text,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );
    
    // Show immediately (optimistic)
    state = AsyncData(current.copyWith(
      messages: [tempMessage, ...current.messages],
    ));
    
    // Send to server
    try {
      final repo = ref.read(chatRepositoryProvider);
      final sentMessage = await repo.sendMessage(tempMessage);
      
      // Replace temp with confirmed
      state = AsyncData(current.copyWith(
        messages: current.messages.map((m) {
          return m.id == tempMessage.id ? sentMessage : m;
        }).toList(),
      ));
    } catch (e) {
      // Mark as failed
      state = AsyncData(current.copyWith(
        messages: current.messages.map((m) {
          if (m.id == tempMessage.id) {
            return m.copyWith(status: MessageStatus.failed);
          }
          return m;
        }).toList(),
      ));
    }
  }
  
  // Retry sending failed message
  Future<void> retryMessage(String conversationId, MessageEntity failedMessage) async {
    return sendMessage(conversationId, failedMessage.text);
  }
}
```

---

### Feed Feature Pattern

**Special Considerations:**
- Paginated REST calls
- Real-time Socket.IO updates
- Complex reactions/comments
- Infinite scroll

**Flow:**
```
Initial Load:
1. Page opens → loads first page (20 posts)
2. Cursor = null (get first 20)
3. Response: { items: [...], nextCursor: "abc123", hasMore: true }
4. Store in state

Scroll to Bottom:
1. User scrolls to end
2. ViewModel.loadMore()
3. Call with nextCursor
4. Append new posts to list
5. Update nextCursor for next load

Real-Time Updates:
1. New post created (by anyone)
2. Socket emits 'new_post'
3. Add to top of feed (prepend)
4. Badge shows "1 new post"
5. User pulls down to refresh old data

Like Post:
1. User taps like button
2. Optimistic: show liked + increment count
3. POST /posts/{id}/like
4. On success: confirmed
5. On failure: revert state
```

**Key Provider Code:**
```dart
@freezed
class FeedPageState with _$FeedPageState {
  const factory FeedPageState({
    required List<PostEntity> posts,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
    @Default(0) int newPostsCount,
    @Default(null) String? error,
  }) = _FeedPageState;
}

@riverpod
class FeedPageNotifier extends _$FeedPageNotifier {
  Future<FeedPageState> build() async {
    final repo = ref.watch(feedRepositoryProvider);
    final page = await repo.getPosts(cursor: null);
    
    // Listen to real-time updates
    _listenToNewPosts();
    
    return FeedPageState(
      posts: page.items,
      nextCursor: page.nextCursor,
    );
  }
  
  void _listenToNewPosts() {
    ref.watch(feedRepositoryProvider).newPostsStream().listen((newPost) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(
          posts: [newPost, ...current.posts],
          newPostsCount: current.newPostsCount + 1,
        ));
      }
    });
  }
  
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current?.nextCursor == null) return;
    
    state = AsyncData(current!.copyWith(isLoadingMore: true));
    
    try {
      final repo = ref.read(feedRepositoryProvider);
      final page = await repo.getPosts(cursor: current.nextCursor);
      
      state = AsyncData(current.copyWith(
        posts: [...current.posts, ...page.items],
        nextCursor: page.nextCursor,
        isLoadingMore: false,
      ));
    } catch (e) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
  
  Future<void> likePost(String postId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    // Optimistic update
    final updatedPosts = current.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          likes: post.likes + 1,
          liked: true,
        );
      }
      return post;
    }).toList();
    
    state = AsyncData(current.copyWith(posts: updatedPosts));
    
    // Confirm with server
    try {
      await ref.read(feedRepositoryProvider).likePost(postId);
    } catch (e) {
      // Revert on error
      state = AsyncData(current);
    }
  }
  
  Future<void> refreshFeed() async {
    state = AsyncData(state.valueOrNull!.copyWith(newPostsCount: 0));
    ref.refresh(build());
  }
}
```

---

### Discovery Feature Pattern

**Special Considerations:**
- Geo-location permission
- Distance calculation
- Pagination of candidates
- Filtering (age, location, preferences)

**Flow:**
```
Initial Load:
1. Request location permission
2. Get user's current coordinates
3. Send to /users/nearby?lat&lng&maxDistanceKm
4. Get paginated candidates within distance
5. Cache results

Swipe/Like/Pass:
1. User likes/passes candidate
2. Optimistic: remove from view
3. POST /matches/{candidateId}/like or skip
4. On success: confirmed
5. On error: show back in deck

Filter Apply:
1. User adjusts age range
2. Filter local candidates first (Hive)
3. If not enough, fetch from API with filters
4. Re-paginate with new filters

Load More:
1. Reaches end of deck
2. Load next page with same filters
3. Append to candidates list
```

**Key Provider Code:**
```dart
@freezed
class DiscoveryState with _$DiscoveryState {
  const factory DiscoveryState({
    required List<CandidateEntity> candidates,
    String? nextCursor,
    @Default(false) bool isLoading,
    required DiscoveryFilters filters,
    @Default(null) String? error,
  }) = _DiscoveryState;
}

@freezed
class DiscoveryFilters with _$DiscoveryFilters {
  const factory DiscoveryFilters({
    @Default(18) int minAge,
    @Default(65) int maxAge,
    @Default(50) int maxDistanceKm,
  }) = _DiscoveryFilters;
}

@riverpod
class DiscoveryNotifier extends _$DiscoveryNotifier {
  late GeolocatorService _geolocator;
  
  Future<DiscoveryState> build() async {
    _geolocator = ref.watch(geolocatorServiceProvider);
    
    // Get user location
    final position = await _geolocator.getCurrentLocation();
    
    // Fetch candidates nearby
    final repo = ref.watch(discoveryRepositoryProvider);
    final page = await repo.getCandidatesNearby(
      latitude: position.latitude,
      longitude: position.longitude,
      maxDistanceKm: 50,
    );
    
    return DiscoveryState(
      candidates: page.items,
      nextCursor: page.nextCursor,
      filters: DiscoveryFilters(),
    );
  }
  
  Future<void> applyFilters(DiscoveryFilters newFilters) async {
    state = AsyncData(state.valueOrNull!.copyWith(
      filters: newFilters,
      isLoading: true,
    ));
    
    try {
      final repo = ref.read(discoveryRepositoryProvider);
      final position = await _geolocator.getCurrentLocation();
      
      // Fetch with new filters
      final page = await repo.getCandidates(
        latitude: position.latitude,
        longitude: position.longitude,
        minAge: newFilters.minAge,
        maxAge: newFilters.maxAge,
        maxDistanceKm: newFilters.maxDistanceKm,
        cursor: null,
      );
      
      state = AsyncData(state.valueOrNull!.copyWith(
        candidates: page.items,
        nextCursor: page.nextCursor,
        filters: newFilters,
        isLoading: false,
      ));
    } catch (e) {
      state = AsyncData(state.valueOrNull!.copyWith(isLoading: false));
    }
  }
  
  Future<void> likeCandidate(String candidateId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    // Optimistic: remove from deck
    final updatedCandidates = current.candidates
        .where((c) => c.id != candidateId)
        .toList();
    
    state = AsyncData(current.copyWith(candidates: updatedCandidates));
    
    // Confirm with server
    try {
      await ref.read(discoveryRepositoryProvider).likeCandidate(candidateId);
    } catch (e) {
      // Revert on error
      state = AsyncData(current);
    }
  }
  
  Future<void> passCandidate(String candidateId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    // Optimistic: remove from deck
    final updatedCandidates = current.candidates
        .where((c) => c.id != candidateId)
        .toList();
    
    state = AsyncData(current.copyWith(candidates: updatedCandidates));
    
    // Confirm with server
    try {
      await ref.read(discoveryRepositoryProvider).passCandidate(candidateId);
    } catch (e) {
      state = AsyncData(current);
    }
  }
  
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current?.nextCursor == null) return;
    
    try {
      final repo = ref.read(discoveryRepositoryProvider);
      final position = await _geolocator.getCurrentLocation();
      
      final page = await repo.getCandidates(
        latitude: position.latitude,
        longitude: position.longitude,
        minAge: current!.filters.minAge,
        maxAge: current.filters.maxAge,
        maxDistanceKm: current.filters.maxDistanceKm,
        cursor: current.nextCursor,
      );
      
      state = AsyncData(current.copyWith(
        candidates: [...current.candidates, ...page.items],
        nextCursor: page.nextCursor,
      ));
    } catch (e) {
      // Silent fail for pagination
    }
  }
}
```

---

## Integration Checklist (When Combining Features)

When you've built multiple features, ensure:

```
□ Auth
  └─ [ ] Login/register works
  └─ [ ] Token refresh on 401
  └─ [ ] Route guard prevents unauthorized access
  └─ [ ] Logout clears all state and caches

□ Chat (depends on Auth)
  └─ [ ] Can only access if authenticated
  └─ [ ] Message history loads
  └─ [ ] Socket.IO connects after login
  └─ [ ] Real-time messages arrive
  └─ [ ] Messages cache locally
  └─ [ ] Pagination works

□ Feed (depends on Auth)
  └─ [ ] Can only access if authenticated
  └─ [ ] Posts load paginated
  └─ [ ] Real-time posts appear at top
  └─ [ ] Like/react works
  └─ [ ] Cache invalidates correctly

□ Discovery (depends on Auth + Location)
  └─ [ ] Can only access if authenticated
  └─ [ ] Location permission requested
  └─ [ ] Candidates load by distance
  └─ [ ] Filters work
  └─ [ ] Like/pass updates backend

□ Profile (depends on Auth)
  └─ [ ] Can edit own profile
  └─ [ ] Photos upload
  └─ [ ] Changes cache locally
  └─ [ ] Can view others' profiles

□ Cross-Feature
  └─ [ ] Deep links work (tapping notification opens right screen)
  └─ [ ] Back button behavior consistent
  └─ [ ] No crashes on logout
  └─ [ ] No auth errors after login
  └─ [ ] Socket reconnects on network change
  └─ [ ] Caches clear on logout
```

---

## Performance Optimization Tips

### Image Loading
```dart
// ✅ Use cached_network_image
CachedNetworkImage(
  imageUrl: 'https://...',
  placeholder: (context, url) => Skeleton(),
  cacheManager: CustomCacheManager(),
  fadeInDuration: Duration(milliseconds: 200),
);

// Configure cache manager
class CustomCacheManager {
  static final instance = CacheManager(
    Config(
      'image_cache',
      stalePeriod: Duration(days: 30),
      maxNrOfCacheObjects: 200,
      fileService: HttpFileService(),
    ),
  );
}
```

### List Performance
```dart
// ✅ Use ListView.builder (not ListView with children)
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) => MessageTile(message: messages[index]),
);

// ✅ Add cacheExtent for smoother scrolling
ListView.builder(
  cacheExtent: 1000, // Render items 1000px beyond viewport
  itemBuilder: ...,
);

// ✅ Use RepaintBoundary for expensive widgets
RepaintBoundary(
  child: ExpensiveMessageBubble(message: message),
);
```

### State Management
```dart
// ✅ Use .select() to prevent rebuilds
final userName = ref.watch(
  userProvider.select((userAsync) => userAsync.whenData((u) => u.name)),
);

// ✅ Use const constructors
const MessageBubble(message: message) // Prevents rebuild if parent rebuilds

// ❌ Avoid watching large objects
final user = ref.watch(userProvider); // Rebuilds on any field change
```

### Network Optimization
```dart
// ✅ Set reasonable timeouts
Dio(BaseOptions(
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 30),
));

// ✅ Gzip compression
headers: {
  'Accept-Encoding': 'gzip',
  'Content-Encoding': 'gzip',
}

// ✅ Only cache what's needed
// Don't cache huge lists, page 1-3 only
if (isFirstPage || isSecondPage || isThirdPage) {
  await localDataSource.cacheData(data);
}
```

### Database (Hive)
```dart
// ✅ Use lazy boxes for large data
await Hive.openLazyBox('messages');

// ✅ Index frequently accessed keys
final box = Hive.box('users');
await box.put('user_123', user); // ID-based access

// ✅ Batch operations
await box.putAll({'key1': val1, 'key2': val2}); // One disk write
```

---

## Security Checklist

```
□ Authentication
  └─ [ ] Tokens stored in secure storage (not shared preferences)
  └─ [ ] No sensitive data in JWT payload
  └─ [ ] Token refresh before expiry or on 401
  └─ [ ] Logout clears all credentials

□ Data Storage
  └─ [ ] Sensitive data not cached to Hive
  └─ [ ] Cache invalidated on logout
  └─ [ ] Hive uses encryption (optional but recommended)

□ API Communication
  └─ [ ] HTTPS only (not HTTP)
  └─ [ ] Certificate pinning (optional but recommended)
  └─ [ ] No API keys in code (use secure storage)
  └─ [ ] Request validation (check input before sending)

□ Permissions
  └─ [ ] Location permission only requested when needed
  └─ [ ] Camera/gallery only accessed for profile photos
  └─ [ ] Contacts never accessed without permission
  └─ [ ] Permissions cached (don't ask repeatedly)

□ Error Handling
  └─ [ ] No sensitive data in error messages
  └─ [ ] Stack traces not shown to user
  └─ [ ] Errors logged to backend securely
  └─ [ ] No URLs or tokens in logs

□ Input Validation
  └─ [ ] Email format validated
  └─ [ ] Password length checked
  └─ [ ] Text inputs sanitized (no scripts)
  └─ [ ] File uploads checked (type, size)
```

---

## Deployment Checklist (Before App Store Release)

### Code Quality
```
□ Testing
  └─ [ ] All unit tests pass
  └─ [ ] All widget tests pass
  └─ [ ] Critical user flows manually tested
  └─ [ ] No console errors or warnings

□ Code Review
  └─ [ ] flutter analyze shows no issues
  └─ [ ] flutter format applied
  └─ [ ] No unused imports
  └─ [ ] No debug code left

□ Performance
  └─ [ ] App starts in < 3 seconds
  └─ [ ] List scrolling smooth (60 fps)
  └─ [ ] Images load and cache properly
  └─ [ ] No memory leaks
```

### Configuration
```
□ Backend URLs
  └─ [ ] API base URL correct
  └─ [ ] WebSocket URL correct
  └─ [ ] No localhost URLs

□ Firebase
  └─ [ ] Crashlytics enabled
  └─ [ ] FCM enabled
  └─ [ ] Analytics enabled
  └─ [ ] Correct project selected (not dev)

□ Environment
  └─ [ ] Removed dev-only code
  └─ [ ] No hardcoded test data
  └─ [ ] Correct database selected (production)
```

### App Metadata
```
□ iOS
  └─ [ ] App name correct
  └─ [ ] Bundle ID correct
  └─ [ ] Version number incremented
  └─ [ ] Build number incremented
  └─ [ ] Icons set (all sizes)
  └─ [ ] Launch screen configured
  └─ [ ] Permissions (Info.plist) set
  └─ [ ] Privacy policy linked

□ Android
  └─ [ ] App name correct
  └─ [ ] Package name correct
  └─ [ ] Version code incremented
  └─ [ ] Version name incremented
  └─ [ ] Icons set (all densities)
  └─ [ ] Splash screen configured
  └─ [ ] Permissions (AndroidManifest.xml) set
  └─ [ ] Min SDK version set (21 or higher)
  └─ [ ] Privacy policy linked
```

### Testing Before Submission
```
□ Device Testing
  └─ [ ] Test on iPhone (latest + 2 older versions)
  └─ [ ] Test on iPad
  └─ [ ] Test on Android (latest + 2 older versions)
  └─ [ ] Test on low-end device (slow network)
  └─ [ ] Test app backgrounding/resuming

□ Network Testing
  └─ [ ] Works on WiFi
  └─ [ ] Works on 4G/5G
  └─ [ ] Works offline (or shows appropriate message)
  └─ [ ] Handles network loss gracefully

□ Feature Testing
  └─ [ ] Login works
  └─ [ ] Chat sends/receives messages
  └─ [ ] Feed loads and refreshes
  └─ [ ] Discovery shows candidates
  └─ [ ] Profile can be edited
  └─ [ ] Logout clears everything
```

---

## Common Issues & Solutions

### Issue: Provider rebuilds unnecessarily
**Symptom:** Widget rebuilds even when data hasn't changed  
**Solution:**
```dart
// Use Freezed to ensure immutability
// Use .select() to watch specific fields
final name = ref.watch(userProvider.select((userAsync) => 
  userAsync.whenData((u) => u.name)
));
```

### Issue: Socket.IO disconnects frequently
**Symptom:** Real-time messages arrive late or not at all  
**Solution:**
```dart
// Configure reconnection
socket = IO.io(
  url,
  IO.OptionBuilder()
    .setReconnectionDelay(1000)
    .setReconnectionDelayMax(5000)
    .setReconnectionAttempts(10)
    .build(),
);

// Add connection monitoring
socket.onConnect((_) => updateConnectionStatus(true));
socket.onDisconnect((_) => updateConnectionStatus(false));
```

### Issue: Messages pile up in memory
**Symptom:** App slows down after scrolling long chat  
**Solution:**
```dart
// Use lazy pagination (only keep 50 messages in memory)
// Older messages move to Hive cache
final recentMessages = messages.take(50).toList();

// Or use virtual scrolling for very large lists
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => MessageTile(messages[index]),
    childCount: messages.length,
  ),
);
```

### Issue: 401 errors in background
**Symptom:** Requests fail with 401 while token is refreshing  
**Solution:**
```dart
// Queue requests during token refresh
// Use mutex or lock
class AuthInterceptor extends Interceptor {
  static final _tokenRefreshMutex = Mutex();
  
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await _tokenRefreshMutex.lock();
      try {
        final newToken = await refreshToken();
        // Retry request with new token
      } finally {
        _tokenRefreshMutex.unlock();
      }
    }
  }
}
```

### Issue: Cached data is stale
**Symptom:** User sees old profile/messages after update  
**Solution:**
```dart
// Implement cache versioning
await hive.put('profile_v1', userData);

// Or implement time-based invalidation
final cachedAt = box.get('profile_timestamp');
if (DateTime.now().difference(cachedAt).inMinutes > 30) {
  await box.clear(); // Invalidate
}

// Or invalidate on specific events
Future<void> updateProfile(Profile newProfile) async {
  await repository.updateProfileOnServer(newProfile);
  ref.invalidate(profileProvider); // Clear cache
}
```

### Issue: Freezed classes not generating
**Symptom:** `freezed.dart` file not found  
**Solution:**
```bash
# Ensure pubspec.yaml has:
dev_dependencies:
  build_runner: ^2.0.0
  freezed_annotation: ^2.0.0
  json_serializable: ^6.0.0

# Run build
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch mode
flutter pub run build_runner watch
```

### Issue: Riverpod override not working in tests
**Symptom:** Mock provider not being used  
**Solution:**
```dart
// Ensure override is done correctly
final container = ProviderContainer(
  overrides: [
    authRepositoryProvider.overrideWithValue(MockAuthRepository()),
  ],
);

// Use .read() to get the value
final repo = container.read(authRepositoryProvider);
expect(repo, isA<MockAuthRepository>());
```

---

## Code Style & Conventions

### Naming
```dart
// ✅ Correct
final userProvider = Provider<User>(...);
class LoginNotifier extends StateNotifier {...}
Future<void> loadUserData() { }
const userInitialState = UserState();

// ❌ Wrong
final USER_PROVIDER = Provider<User>(...); // Screaming case
class LoginViewModel extends StateNotifier {...}; // ViewModel suffix outdated
Future<void> LoadUserData() { }; // PascalCase for functions
var userInitialState = UserState(); // No const
```

### File Organization
```
File length: < 300 lines
├─ Imports (group: dart, packages, relative)
├─ Constants
├─ Type/Model definitions
├─ Main class/function
└─ Helper classes/functions

Comments:
├─ /// for public APIs (generate docs)
├─ // for implementation details
└─ // TODO or FIXME for future work
```

### Import Order
```dart
// ✅ Correct order
import 'dart:async'; // Dart imports first

import 'package:flutter/material.dart'; // Packages
import 'package:riverpod/riverpod.dart';

import '../../../core/error/failure.dart'; // Relative imports last
import '../../domain/entities/user_entity.dart';
```

---

## Database Migrations (If Using SQLite Later)

When transitioning from Hive to Sqlite:

```dart
// Keep Hive interface, swap implementation
abstract class LocalDataSource {
  Future<User> getUser();
  Future<void> saveUser(User user);
}

// Hive implementation
class HiveLocalDataSourceImpl implements LocalDataSource {
  // Current implementation
}

// SQLite implementation (for later)
class SqliteLocalDataSourceImpl implements LocalDataSource {
  // New implementation
}

// In repository, just swap
final dataSource = useSqlite 
  ? SqliteLocalDataSourceImpl() 
  : HiveLocalDataSourceImpl();
```

---

## Version Control Strategy

### Commit Message Format
```
[TYPE] Brief description (50 chars max)

Longer explanation if needed (wrap at 72 chars)

Closes #123
```

**Types:**
- `[feat]` New feature
- `[fix]` Bug fix
- `[refactor]` Code refactoring
- `[test]` Test addition/fix
- `[docs]` Documentation
- `[chore]` Build, dependencies
- `[perf]` Performance improvement

### Branch Naming
```
feature/[name]        # New feature
fix/[issue-number]    # Bug fix
refactor/[name]       # Refactoring
test/[name]           # Test addition
```

### PR Template
```markdown
## Description
Brief summary of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change

## How to Test
Steps to verify the changes

## Checklist
- [ ] Tests pass
- [ ] No console warnings
- [ ] Code formatted
- [ ] Docs updated if needed
```

---

## Key Resources Quick Links

| Resource | URL | Use For |
|---|---|---|
| Riverpod Docs | https://riverpod.dev | State management |
| Flutter Docs | https://flutter.dev/docs | General Flutter |
| Dio | https://pub.dev/packages/dio | HTTP client |
| Socket.IO | https://pub.dev/packages/socket_io_client | Real-time |
| GoRouter | https://pub.dev/packages/go_router | Navigation |
| Freezed | https://pub.dev/packages/freezed | Immutable models |
| Firebase | https://firebase.google.com/docs/flutter | Backend services |
| Clean Code | https://youtu.be/B67DD4FeApr | Architecture |

---

## Final Reminders

✅ **Do:**
- Test edge cases (401, timeout, no internet)
- Log errors with context
- Cache strategically
- Use immutable models
- Keep layers separated
- Write tests as you code
- Review code before committing
- Update docs when architecture changes

❌ **Don't:**
- Skip error handling
- Mix layers (Repository ≠ UI logic)
- Hardcode values
- Use mutable state
- Call async inside build()
- Trust user input
- Ignore warnings
- Leave debug code

🚀 **When You're Stuck:**
1. Check the error message (read it fully!)
2. Search similar issue (Stack Overflow, GitHub)
3. Look at test files for examples
4. Print debug info (don't leave in code)
5. Ask AI assistant with full context

Good luck! You've got this! 💪
