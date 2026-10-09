# 📋 Core Java Course Evaluation — Marking Criteria Map

This document provides a direct mapping between each required course grading dimension and the exact classes, interfaces, and methods in the codebase.

---

## 1. Object-Oriented Programming (OOP) — [10 Marks]

| Grading Requirement | Implementation File(s) | Description / Key Highlights |
|---|---|---|
| **Abstract Class & Subclasses** | [`src/main/java/com/recipeshare/model/User.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/model/User.java)<br>[`src/main/java/com/recipeshare/model/AdminUser.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/model/AdminUser.java)<br>[`src/main/java/com/recipeshare/model/RegularUser.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/model/RegularUser.java) | Abstract `User` defines abstract methods `getDashboardPath()` and `canManageUsers()`. `AdminUser` overrides them to return `/admin/dashboard.html` and `true`; `RegularUser` returns `/user/dashboard.html` and `false`. |
| **UserFactory (Factory Pattern)** | [`src/main/java/com/recipeshare/model/UserFactory.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/model/UserFactory.java) | Polymorphic object creation using `UserFactory.createUser(role, ...)`. |
| **Interfaces Contract** | [`src/main/java/com/recipeshare/oop/Identifiable.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/oop/Identifiable.java)<br>[`src/main/java/com/recipeshare/oop/Approvable.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/oop/Approvable.java)<br>[`src/main/java/com/recipeshare/oop/Searchable.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/oop/Searchable.java)<br>[`src/main/java/com/recipeshare/oop/ActivityHandler.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/oop/ActivityHandler.java) | `Recipe` implements both `Identifiable<Long>` and `Approvable`. `RecipeService` implements `Searchable<RecipeCard>`. `DatabaseActivityHandler` and `SseActivityHandler` implement `ActivityHandler`. |
| **Runtime Polymorphism** | [`src/main/java/com/recipeshare/concurrency/ActivityEventProcessor.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/concurrency/ActivityEventProcessor.java) | Dispatches asynchronously to `List<ActivityHandler>` via dynamic method dispatch at runtime. |
| **Method Overloading** | [`src/main/java/com/recipeshare/service/RecipeService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/RecipeService.java) | Multiple `search(...)` overloads: `search(keyword, page, size)`, `search(keyword, minRating, sort, page, size)`, and `search(page, size)`. |
| **Custom Exception Hierarchy** | [`src/main/java/com/recipeshare/exception/RecipeAppException.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/exception/RecipeAppException.java)<br>[`src/main/java/com/recipeshare/exception/GlobalExceptionHandler.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/exception/GlobalExceptionHandler.java) | Root `RecipeAppException` subclassed by `ResourceNotFoundException`, `DuplicateException`, `ValidationException`, `AuthenticationFailedException`, `AccessDeniedException`, and `DatabaseException`. Handled via `@RestControllerAdvice`. |

---

## 2. Collections and Generics — [6 Marks]

| Data Structure / Concept | Implementation File | Usage & Description |
|---|---|---|
| **Generic LRU Cache (extends LinkedHashMap)** | [`src/main/java/com/recipeshare/collections/Cache.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/collections/Cache.java) | Custom generic `Cache<K,V>` with access-order eviction, used in `SettingService` and `RecipeService` (featured recipes). |
| **Generic Page<T> & Result<T>** | [`src/main/java/com/recipeshare/collections/Page.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/collections/Page.java)<br>[`src/main/java/com/recipeshare/collections/Result.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/collections/Result.java) | Type-safe pagination metadata wrapper and monad result envelope. |
| **TreeMap (Natural Ordering)** | [`src/main/java/com/recipeshare/service/StatsService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/StatsService.java) | `getSubmissionsPerDay(days)` groups submissions by date into a sorted `TreeMap<String, Long>`. |
| **EnumMap (Type-Safe Enum Keys)** | [`src/main/java/com/recipeshare/service/StatsService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/StatsService.java) | `EnumMap<RecipeStatus, Long>` and `EnumMap<Role, Long>` for status/role distribution stats. |
| **PriorityQueue (Heap)** | [`src/main/java/com/recipeshare/service/RecipeService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/RecipeService.java) | Max-heap `PriorityQueue<RecipeCard>` with `Comparator` for extracting Top-N recipes by rating. |
| **ArrayDeque (Buffer Window)** | [`src/main/java/com/recipeshare/service/ActivityService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/ActivityService.java) | In-memory sliding window queue `ArrayDeque<ActivityLog>` for fast recent activity reads. |
| **Streams, Collectors, & Comparator** | [`src/main/java/com/recipeshare/service/StatsService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/StatsService.java) | `Stream.filter()`, `Collectors.groupingBy()`, `Collectors.counting()`, `Comparator.comparingDouble()`. |

---

## 3. Multithreading and Synchronization — [4 Marks]

| Multithreading Component | Implementation File | Usage & Description |
|---|---|---|
| **BlockingQueue + Worker Pool** | [`src/main/java/com/recipeshare/concurrency/ActivityEventProcessor.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/concurrency/ActivityEventProcessor.java) | `ArrayBlockingQueue<ActivityEvent>` capacity 1000 consumed by `ExecutorService` fixed pool of 2 worker threads. |
| **Per-Recipe ReentrantLock** | [`src/main/java/com/recipeshare/service/RatingService.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/service/RatingService.java) | `ConcurrentHashMap<Long, ReentrantLock>` serializes concurrent rating submissions on the same recipe while allowing independent recipes to rate in parallel. |
| **Atomic View Counter + Scheduler** | [`src/main/java/com/recipeshare/concurrency/ViewCountFlusher.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/concurrency/ViewCountFlusher.java) | `ConcurrentHashMap<Long, AtomicInteger>` flushed in batch to DB every 15s via `ScheduledExecutorService` and on `@PreDestroy`. |
| **CopyOnWriteArrayList for SSE** | [`src/main/java/com/recipeshare/oop/SseActivityHandler.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/oop/SseActivityHandler.java) | Thread-safe `CopyOnWriteArrayList<SseEmitter>` pushing real-time events to connected admin clients. |
| **50-Thread Concurrency JUnit Test** | [`src/test/java/com/recipeshare/ConcurrencyTest.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/test/java/com/recipeshare/ConcurrencyTest.java) | Rigorous automated test executing 50 concurrent threads simultaneously using `CountDownLatch` and `ExecutorService`. |

---

## 4. Database Operation Classes — [7 Marks]

| Class | Type | File Location |
|---|---|---|
| `GenericDao<T, ID>` | Generic DAO Interface | [`src/main/java/com/recipeshare/dao/GenericDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/GenericDao.java) |
| `AbstractJdbcDao<T, ID>` | Template Abstract Base | [`src/main/java/com/recipeshare/dao/AbstractJdbcDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/AbstractJdbcDao.java) |
| `UserDao` | Concrete DAO | [`src/main/java/com/recipeshare/dao/UserDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/UserDao.java) |
| `RecipeDao` | Concrete DAO | [`src/main/java/com/recipeshare/dao/RecipeDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/RecipeDao.java) |
| `RatingDao` | Concrete DAO | [`src/main/java/com/recipeshare/dao/RatingDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/RatingDao.java) |
| `CommentDao` | Concrete DAO | [`src/main/java/com/recipeshare/dao/CommentDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/CommentDao.java) |
| `SettingDao` | Concrete DAO | [`src/main/java/com/recipeshare/dao/SettingDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/SettingDao.java) |
| `ActivityLogDao` | Concrete DAO | [`src/main/java/com/recipeshare/dao/ActivityLogDao.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/ActivityLogDao.java) |

---

## 5. JDBC Connectivity — [3 Marks]

- **Configuration File**: [`src/main/resources/db.properties`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/resources/db.properties)
- **DatabaseManager Singleton**: [`src/main/java/com/recipeshare/db/DatabaseManager.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/db/DatabaseManager.java) (Double-checked locking singleton).
- **Custom Thread-Safe ConnectionPool**: [`src/main/java/com/recipeshare/db/ConnectionPool.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/db/ConnectionPool.java) (ArrayBlockingQueue of size 8, Dynamic `Proxy` returns connections on `close()`).
- **DatabaseMetaData Log**: Logged automatically on startup in `DatabaseManager` (Product Name, Version, Driver Name, Driver Version).

---

## 6. Implement JDBC — [3 Marks]

- **PreparedStatement with try-with-resources**: Used throughout all DAOs and `AbstractJdbcDao`.
- **RowMapper<T> Functional Interface**: [`src/main/java/com/recipeshare/dao/RowMapper.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/dao/RowMapper.java).
- **Generated Keys Retrieval**: Handled generically in `AbstractJdbcDao.executeInsertAndReturnGeneratedKey()`.
- **LIMIT / OFFSET Pagination**: Implemented in `AbstractJdbcDao.executePagedQuery()` and `RecipeDao`.
- **Batch Inserts**: Implemented in `DataSeeder.seedRecipes()` and `RecipeDao.batchUpdateViewCounts()`.
- **TransactionManager (Commit & Rollback)**: [`src/main/java/com/recipeshare/db/TransactionManager.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/db/TransactionManager.java) with `ThreadLocal<Connection>`.
- **Relational DDL & Constraints**: [`src/main/java/com/recipeshare/db/SchemaInitializer.java`](file:///Users/irfanansari/Downloads/online%20recipe%20platform/recipe-platform/src/main/java/com/recipeshare/db/SchemaInitializer.java) (Foreign keys, indexes, and `UNIQUE(recipe_id, user_id)` on ratings).
