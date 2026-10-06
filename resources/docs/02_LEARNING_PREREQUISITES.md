# Learning Prerequisites & Skills Checklist
## What You Need to Know to Execute This Architecture

This guide separates what you should know *before starting* vs. what you can *learn during development*.

---

## Pre-Project Requirements (Must Have Before Week 1)

### 1. Flutter Fundamentals
- [x] **Flutter widget system** (StatelessWidget, StatefulWidget)
  - You likely know this well already as a mid-level Flutter dev
  - What you might be weak on: `ConsumerWidget` vs `StatefulWidget`

**Learn:**
```dart
// OLD (StatefulWidget)
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) { ... }
}

// NEW (ConsumerWidget with Riverpod)
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(someProvider);
    return Text(data);
  }
}
```

**Time:** If you know StatefulWidget, ConsumerWidget is 1 hour
**Resource:** https://riverpod.dev/docs/essentials/first_steps

---

### 2. Riverpod 3.x (State Management)
This is 40% of your job. You need solid understanding before week 1.

**Must Know:**
- [ ] `Provider` (simple state, read-only)
- [ ] `StateProvider` (mutable state, like `setState()`)
- [ ] `FutureProvider` (async data, auto-caching)
- [ ] `StreamProvider` (real-time data)
- [ ] `StateNotifierProvider` (complex state with methods)
- [ ] `.watch()` vs `.read()` (when to use each)
- [ ] `.select()` (optimize rebuilds)
- [ ] `.family` (parameterized providers)
- [ ] Provider override (for testing)
- [ ] `ref.invalidate()` and `.refresh()`
- [ ] Async value handling (`.when()` pattern)

**Learn:**
```dart
// 1. Simple state (counter)
final counterProvider = StateProvider<int>((ref) => 0);

// Usage
ref.watch(counterProvider); // Get current value
ref.read(counterProvider.notifier).state = 5; // Update

// 2. Async data (API call)
final usersProvider = FutureProvider<List<User>>((ref) async {
  final response = await dio.get('/users');
  return response.data.map((u) => User.fromJson(u)).toList();
});

// Usage
final asyncValue = ref.watch(usersProvider);
asyncValue.when(
  data: (users) => ListView(children: users.map((u) => Text(u.name))),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget(error: err),
);

// 3. Real-time data (WebSocket)
final messagesProvider = StreamProvider<Message>((ref) {
  return socket.on('new_message').map((data) => Message.fromJson(data));
});

// 4. Complex state (form with methods)
final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());
  
  void setEmail(String email) => state = state.copyWith(email: email);
  void setPassword(String password) => state = state.copyWith(password: password);
  
  Future<void> login() async {
    state = state.copyWith(isLoading: true);
    try {
      await authRepository.login(state.email, state.password);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

**Time:** 8-12 hours if you've done other state management (Redux, GetX, BloC)
**Time:** 20+ hours if state management is new
**Resource:** https://riverpod.dev/docs/essentials

---

### 3. HTTP Networking with Dio
You need to understand Dio + interceptors.

**Must Know:**
- [ ] Basic Dio setup and requests (GET, POST, PUT, DELETE)
- [ ] Request/response interceptors
- [ ] Auth interceptor (add JWT to headers)
- [ ] Error interceptor (log errors, retry logic)
- [ ] Timeout configuration
- [ ] JSON serialization/deserialization

**Learn:**
```dart
// Dio setup
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 30),
  headers: {'Content-Type': 'application/json'},
));

// Add interceptors
dio.interceptors.add(AuthInterceptor());
dio.interceptors.add(ErrorInterceptor());

// Make request
final response = await dio.get('/users/$id');
final user = User.fromJson(response.data);

// Interceptor example
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getTokenFromStorage();
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Refresh token + retry
    }
    handler.next(err);
  }
}
```

**Time:** 4-6 hours
**Resource:** https://pub.dev/packages/dio

---

### 4. Local Storage (Hive + Secure Storage)

**Must Know:**
- [ ] Hive basics (boxes, CRUD operations)
- [ ] Registering custom adapters
- [ ] flutter_secure_storage for sensitive data
- [ ] Box types (regular vs persistent)

**Learn:**
```dart
// Hive setup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Register adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(MessageModelAdapter());
  
  // Open boxes
  await Hive.openBox('auth');
  await Hive.openBox('users');
  await Hive.openBox('messages');
  
  runApp(MyApp());
}

// Use Hive
final box = Hive.box('users');
await box.put('current_user', userModel); // Save
final user = box.get('current_user'); // Read
await box.delete('current_user'); // Delete

// Secure storage (for tokens)
final secureStorage = FlutterSecureStorage();
await secureStorage.write(key: 'access_token', value: token);
final token = await secureStorage.read(key: 'access_token');
```

**Time:** 3-4 hours
**Resource:** https://pub.dev/packages/hive + https://pub.dev/packages/flutter_secure_storage

---

### 5. JSON Serialization (Freezed + JSON Serializable)
You need `freezed` + `json_serializable` for models.

**Must Know:**
- [ ] Generating classes with `freezed`
- [ ] `@JsonKey` annotations
- [ ] Running `flutter pub run build_runner build`
- [ ] Why freezed is better than manual copyWith()

**Learn:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'profile_image') String? profileImage,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
    _$UserModelFromJson(json);
}

// Usage
final user = UserModel(id: '1', email: 'test@x', name: 'Test');
final user2 = user.copyWith(name: 'Test 2'); // Immutable copy
final json = user.toJson(); // Serialize
final user3 = UserModel.fromJson(json); // Deserialize
```

**Time:** 2-3 hours
**Resource:** https://pub.dev/packages/freezed + https://pub.dev/packages/json_serializable

---

### 6. Navigation with GoRouter
You need to understand GoRouter + redirect guards.

**Must Know:**
- [ ] Route definition (GoRoute, nested routes)
- [ ] Navigation (context.go(), context.push())
- [ ] Path parameters (`:id` in routes)
- [ ] Redirect guards (auth-protected routes)
- [ ] Deep linking basics

**Learn:**
```dart
final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    // Check if user is logged in
    final isLoggedIn = checkAuthStatus();
    final isAuthRoute = state.matchedLocation.startsWith('/auth');
    
    // Redirect to login if not authenticated
    if (!isLoggedIn && !isAuthRoute) {
      return '/auth/login';
    }
    
    // Redirect to home if already logged in
    if (isLoggedIn && isAuthRoute) {
      return '/';
    }
    
    return null; // No redirect needed
  },
  routes: [
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: 'chat/:conversationId',
          builder: (context, state) {
            final conversationId = state.pathParameters['conversationId']!;
            return ChatDetailPage(conversationId: conversationId);
          },
        ),
      ],
    ),
  ],
);
```

**Time:** 3-4 hours
**Resource:** https://pub.dev/packages/go_router

---

## During-Project Learning (Can Learn While Building)

### 7. Socket.IO Client
Learn as you build chat feature.

**Must Know:**
- [ ] Basic Socket.IO connection
- [ ] Listening to events (`.on()`)
- [ ] Emitting events (`.emit()`)
- [ ] Auto-reconnection
- [ ] Disconnect handling

**Learn:**
```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socket = IO.io('https://api.example.com', 
  IO.OptionBuilder()
    .setTransports(['websocket'])
    .enableAutoConnect()
    .setReconnectionDelay(1000)
    .setReconnectionDelayMax(5000)
    .build(),
);

socket.onConnect((_) {
  print('Connected');
  socket.emit('join_chat', {'conversationId': 'conv_123'});
});

socket.on('receive_message', (data) {
  print('New message: $data');
  // Update UI with new message
});

socket.onDisconnect((_) {
  print('Disconnected');
});
```

**Time:** 3-4 hours
**Resource:** https://pub.dev/packages/socket_io_client

---

### 8. Firebase (Crashlytics + Cloud Messaging)
Learn as you implement logging + push notifications.

**Must Know:**
- [ ] Firebase initialization
- [ ] Crashlytics reporting
- [ ] FCM token setup
- [ ] Handling push notifications

**Learn:**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Setup Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  
  // Setup FCM
  final fcm = FirebaseMessaging.instance;
  final token = await fcm.getToken();
  print('FCM Token: $token');
  
  runApp(MyApp());
}

// Handle foreground messages
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Message: ${message.notification?.title}');
});
```

**Time:** 4-6 hours
**Resource:** https://firebase.google.com/docs/flutter/setup

---

### 9. Testing (Unit + Widget Tests)
Learn incrementally as you build features.

**Must Know:**
- [ ] Unit testing with `test` package
- [ ] Widget testing with `flutter_test`
- [ ] Mocking with `mocktail`
- [ ] FakeAsync for testing async code

**Learn:**
```dart
// Unit test example
void main() {
  group('ChatRepository', () {
    late ChatRepository repository;
    late MockChatDataSource mockDataSource;
    
    setUp(() {
      mockDataSource = MockChatDataSource();
      repository = ChatRepository(mockDataSource);
    });
    
    test('returns messages from datasource', () async {
      when(() => mockDataSource.getMessages('conv_123'))
        .thenAnswer((_) async => [mockMessage1, mockMessage2]);
      
      final result = await repository.getMessages('conv_123');
      
      expect(result, [mockMessage1, mockMessage2]);
      verify(() => mockDataSource.getMessages('conv_123')).called(1);
    });
  });
}

// Widget test example
void main() {
  testWidgets('Login page shows email error', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));
    
    await tester.enterText(find.byType(TextField).first, 'invalid');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    
    expect(find.text('Invalid email'), findsOneWidget);
  });
}
```

**Time:** 6-8 hours (spread across project)
**Resource:** https://pub.dev/packages/test + https://pub.dev/packages/mocktail

---

### 10. Architecture Concepts & Clean Code
Learn these patterns as you implement features.

**Must Know:**
- [ ] Separation of concerns (why layers exist)
- [ ] Dependency injection (why Riverpod > service locator)
- [ ] Repository pattern (abstraction over data)
- [ ] Error handling best practices
- [ ] Immutability benefits (why Freezed is important)

**Learn (Example: Auth Feature)**
```
1. User taps login button
2. View → ViewModel.login()
3. ViewModel → Repository.login()
4. Repository → RemoteDataSource.POST /auth/login
5. RemoteDataSource → Dio (network request)
6. Error occurs → DioException
7. ErrorHandler maps to Failure
8. AppLogger logs error
9. Repository catches Failure, tries LocalDataSource (cache)
10. Returns cached data or throws Failure
11. ViewModel catches Failure, updates state with error
12. View watches ViewModel state, shows error message
13. User taps retry → back to step 2
```

**Key principle:** Each layer has ONE job. Don't mix concerns.

**Time:** 10-15 hours (conceptual, learned through implementation)
**Resource:** https://www.youtube.com/watch?v=B67DD4FeApr (Flutter architecture by Andrea Bizzotto)

---

### 11. Backend API Design (For Your Node Backend)
You might not need to implement this, but understand it.

**Must Know:**
- [ ] REST endpoint design (GET, POST, PUT, DELETE semantics)
- [ ] Pagination (cursor-based vs offset-based)
- [ ] Error responses (structure, status codes)
- [ ] Authentication (JWT, refresh tokens)
- [ ] Rate limiting

**Learn:**
```
Endpoint design:
GET /users              # List users
POST /users             # Create user
GET /users/:id          # Get specific user
PUT /users/:id          # Update user
DELETE /users/:id       # Delete user
GET /users/:id/profile  # Get user profile (nested resource)

Pagination:
GET /posts?cursor=abc&limit=20
Response: { items: [...], nextCursor: "xyz", hasMore: true }

Error response:
{
  "code": 400,
  "message": "Validation failed",
  "errors": {
    "email": "Invalid email format"
  }
}

Authentication:
Authorization: Bearer eyJhbGc...
```

**Time:** 2-3 hours (mostly awareness)
**Resource:** https://restfulapi.net/

---

### 12. Project-Specific Concepts

#### A. Geo-Location & Distance Calculation
Needed for discovery feature.

**Must Know:**
- [ ] Requesting location permission
- [ ] Getting user coordinates
- [ ] Haversine formula (distance between two points)
- [ ] MongoDB geospatial queries (backend, but good to know)

**Learn:**
```dart
import 'package:geolocator/geolocator.dart';

// Get user location
final permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}

final position = await Geolocator.getCurrentPosition();
print('${position.latitude}, ${position.longitude}');

// Calculate distance
double distanceInMeters = Geolocator.distanceBetween(
  lat1, lng1,  // My location
  lat2, lng2,  // Other user location
);
double distanceInKm = distanceInMeters / 1000;
```

**Time:** 2-3 hours
**Resource:** https://pub.dev/packages/geolocator

---

#### B. Real-Time Messaging Patterns
Needed for chat + feed features.

**Must Know:**
- [ ] Optimistic UI updates (show message before confirmation)
- [ ] Message deduplication (same message from REST + Socket)
- [ ] Pagination + real-time merge (old messages + new messages)
- [ ] Typing indicators
- [ ] Read receipts

**Learn:**
```dart
// Optimistic update
Future<void> sendMessage(String text) async {
  final tempMessage = Message(
    id: 'temp_${DateTime.now().timestamp}',
    text: text,
    senderId: currentUserId,
    timestamp: DateTime.now(),
    status: MessageStatus.sending,
  );
  
  // Show message immediately (optimistic)
  state = AsyncData(state.value!.copyWith(
    messages: [tempMessage, ...state.value!.messages],
  ));
  
  // Send to server
  try {
    final response = await repository.sendMessage(text);
    
    // Replace temp message with confirmed message
    state = AsyncData(state.value!.copyWith(
      messages: state.value!.messages.map((m) {
        if (m.id == tempMessage.id) {
          return response; // Confirmed message with real ID
        }
        return m;
      }).toList(),
    ));
  } catch (e) {
    // Mark message as failed
    state = AsyncData(state.value!.copyWith(
      messages: state.value!.messages.map((m) {
        if (m.id == tempMessage.id) {
          return m.copyWith(status: MessageStatus.failed);
        }
        return m;
      }).toList(),
    ));
  }
}
```

**Time:** 4-6 hours (during chat implementation)
**Resource:** https://socket.io/docs/v4/emitting-events/

---

#### C. Pagination (Cursor-Based)
Needed for feed + discovery features.

**Must Know:**
- [ ] Why cursor-based > offset-based
- [ ] How to encode cursors
- [ ] Merging paginated data

**Learn:**
```dart
// Cursor pagination (better for scrolling)
GET /posts?cursor=abc123&limit=20

Response:
{
  "items": [...20 posts...],
  "nextCursor": "def456",
  "hasMore": true
}

// ViewModel implementation
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
    
    final repo = ref.read(feedRepositoryProvider);
    final page = await repo.getPosts(cursor: current!.nextCursor);
    
    state = AsyncData(current.copyWith(
      posts: [...current.posts, ...page.items],
      nextCursor: page.nextCursor,
    ));
  }
}
```

**Time:** 2-3 hours
**Resource:** https://stripe.com/docs/api/pagination/cursor

---

## Skill Level Assessment

### Before You Start (Honest Self-Assessment)

Rate yourself 1-5 (1=no knowledge, 5=expert):

| Skill | Rating | Notes |
|---|---|---|
| Flutter basics | ___ | StatelessWidget, StatefulWidget, basic widgets |
| Dart language | ___ | Functions, classes, async/await, generics |
| HTTP networking | ___ | Making API calls, JSON serialization |
| State management | ___ | Any prior experience (Redux, BloC, GetX) |
| Local storage | ___ | Shared preferences, files, databases |
| Testing | ___ | Unit tests, mocking, widget tests |
| Architecture patterns | ___ | Clean code, separation of concerns |
| Backend/APIs | ___ | Understanding REST, error handling |

**If you're strong in:**
- Flutter basics + Dart → 4-5 weeks to MVP
- + State management experience → 3-4 weeks to MVP
- + Architecture knowledge → 2-3 weeks to MVP

**If you're weaker in:**
- State management or testing → add 1-2 weeks
- Architecture concepts → add 2-3 weeks
- Multiple weak areas → 6-8 weeks is realistic

---

## Recommended Learning Path

### Week 0 (Before Project Starts) - 20 Hours
```
Day 1-2: Riverpod deep dive (FutureProvider, StreamProvider, StateNotifier)
Day 3:   Dio + interceptors
Day 4:   Hive + Freezed
Day 5:   GoRouter + auth guards
```

### Week 1-2: Foundation Phase - Learn While Building
```
Build auth feature (learn error handling, logging)
Build profile feature (learn caching strategy)
```

### Week 2-4: Core Features - Learn As Needed
```
Build discovery (learn pagination, geo-location)
Build feed (learn real-time merging)
Build chat (learn Socket.IO, complex state)
```

### Week 5-6: Polish & Testing
```
Add Firebase Crashlytics + FCM
Write unit tests
Write widget tests for critical screens
```

---

## External Resources (Bookmarked)

### Official Docs
- [ ] Riverpod: https://riverpod.dev/docs/essentials
- [ ] Flutter: https://flutter.dev/docs
- [ ] Dio: https://pub.dev/packages/dio
- [ ] GoRouter: https://pub.dev/packages/go_router

### Video Tutorials (YouTube)
- [ ] "Riverpod Tutorial" by Riverpod team: https://www.youtube.com/playlist?list=PLz3nD1FQnHO7Rg0J14bPX4IxqHZQjJvXu
- [ ] "Flutter Architecture" by Andrea Bizzotto: https://www.youtube.com/watch?v=B67DD4FeApr
- [ ] "Dio HTTP Client" by Flutter Explained: https://www.youtube.com/watch?v=jjW7T0R_JAU

### Blogs & Articles
- [ ] "Clean Architecture in Flutter" by Philipp Lapcsak
- [ ] "Riverpod Tips & Tricks" by Remi Rousselet
- [ ] "Cursor Pagination" by Stripe docs

### Books (Optional)
- [ ] "Clean Architecture" by Robert Martin
- [ ] "Refactoring" by Martin Fowler

---

## Things You Already Know (Probably)

Given you're a mid-level Flutter dev:

✅ Stateless/StatefulWidget  
✅ Basic Dart syntax (classes, functions, async)  
✅ Basic HTTP requests  
✅ Widget composition and layout  
✅ Navigation basics (Navigator/MaterialPageRoute)  
✅ Shared preferences  

You're likely weak in:
❌ Riverpod (if you've used GetX/BloC)  
❌ Advanced architecture patterns  
❌ Testing (especially widget tests)  
❌ Error handling best practices  
❌ Real-time data with WebSocket  

---

## Quick Wins (Do These First)

1. **Riverpod Fundamentals** (most impact on project)
   - [ ] Read https://riverpod.dev/docs/essentials in 3 hours
   - [ ] Write 3 small examples (counter, API call, form)
   - [ ] Understand `.watch()`, `.read()`, `.when()`

2. **Error Handling Pattern** (saves debugging time later)
   - [ ] Understand Failure classes
   - [ ] Understand ErrorHandler mapping
   - [ ] See how it flows through layers

3. **Architecture Mindset** (helps every feature)
   - [ ] Read the combined architecture guide (this file)
   - [ ] Draw the flow diagram (data → ViewModel → UI)
   - [ ] Understand why each layer exists

These 3 things unblock everything else.

---

## Final Checklist Before Week 1

### Knowledge
- [ ] I understand Riverpod providers (at least FutureProvider, StateNotifier)
- [ ] I can build a Dio interceptor
- [ ] I understand the architecture layers and why they exist
- [ ] I know how to use GoRouter with redirects

### Setup
- [ ] Flutter SDK latest version installed
- [ ] Android Studio / VS Code with Flutter extensions
- [ ] Emulator or physical device for testing
- [ ] Git repo initialized

### Dependencies Reviewed
- [ ] pubspec.yaml updated with all packages
- [ ] Run `flutter pub get`
- [ ] No version conflicts

### Environment
- [ ] Firebase project created (for Crashlytics + FCM)
- [ ] Node/Express backend running locally
- [ ] Socket.IO server accessible
- [ ] MongoDB connected to backend

Once all checked, you're ready to start Phase 1! 🚀
