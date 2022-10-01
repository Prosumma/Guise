# Guise 10

Guise is a flexible, minimal dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Supports `throw`ing and `async` initializers and resolution
- [x] Simplifies unit testing
- [x] Pass arbitrary state when resolving
- [x] Lazy resolution
- [x] Swift 5.7+
- [x] Support for iOS 8.0+, macOS 10.9+, watchOS 2+, tvOS 9+

### What Makes Guise Better Than Those Other Guys?

- Guise doesn't require any modification to the types you register. There are no special interfaces like `Injectable` or `Component` to implement. There are no special initializers or properties to add. Any type can be registered as is.
- Guise was designed with Swift in mind. Other DI frameworks for Swift appear to be translations of frameworks from other languages, particularly C&#x266f; and Java. These languages have strengths and weaknesses that are different from those of Swift, and those strengths and weaknesses are reflected in the design of these frameworks. This makes them clumsy in Swift.
- Many of these frameworks register _types_ directly. Guise registers _blocks_ directly and _types_ indirectly. This simple distinction removes an enormous amount of complexity while introducing greater compile-time safety. 
- Guise was designed to be simple rather than easy. Turns out it's both.

### Changes

Guise 10 is not backwards compatible with 9.

- [x] Guise 10 removes support for CocoaPods and Carthage. This is now a pure Swift package. 
- [x] Metadata, containers and names have been merged into `tags`. (See below.)
- [x] Injection has been removed but will make a comeback in a point release. (If you need it, use version 9 for now.)
- [x] The global `Guise` type has been removed. If you want a global container, you'll have to do it yourself.

### Basic Documentation

#### Registration

To register a dependency with the container, four facts are needed: The _type_ to be registered, the _tags_ under which it will be registered, the _arguments_ needed in order to resolve the registration, and the _lifetime_ of the registration. The first three uniquely identify a registration. We'll discuss the fourth fact, lifetime, below.

Let's start with these one by one.

##### Types 

```swift
let container = Container()
container.register(Service.self) { _ in
  Service()
}
```

The first argument to `register` tells Guise (and Swift) which type we're registering, and the block passed at the end tells Guise how to construct that type. (Ignore the `_` parameter for the moment.)

Since the type we're registering is the same as the return type of the block, we can omit the first argument of `register`:

```swift
container.register { _ in Service() }
```

One of the main purposes of dependency injection is to locate implementations of abstract interfaces, so that they can be substituted in unit tests or for some other purpose. In fact, that's why this framework is called Guise.

> **Guise**, _n._ An external form, appearance, or manner of presentation, typically concealing the true nature of something.

```swift
protocol Service {
  func performService() async
}

class ConcreteService: Service {
  // Perhaps this one talks to a real database
}

class TestService: Service {
  // This is the one we want in unit tests
}

let container = Container()
container.register(Service.self) { _ in
  ConcreteService()
}
```

Notice that in this example, the block returns `ConcreteService` but the registered type is `Service`. Another way to express this is

```swift
container.register { _ in ConcreteService() as Service }
```

Later, when we resolve this registration, we ask for `Service`, not `ConcreteService`.

For simple registrations that have no arguments, Guise has a convenient overload which uses an `@autoclosure`:

```swift
container.register(instance: ConcreteService() as Service)
```

##### Tags

Tags can help locate, describe, and disambiguate registrations. A tag can be any `Hashable` type, such as `String`, `UUID`, `Int` or a custom type you create yourself.

```swift
enum Types: Equatable, Hashable {
  case plugin
}

container.register(Plugin.self, tags: Types.plugin, 1, instance: PluginImpl1())
```

The order of tags is not important and any number may be used. Tags are collected into a `Set<AnyHashable>`, so repetition has no effect.

Because the tags used in a registration are part of the unique `Key` that identifies that registration, the same tags must be used when resolving:

```swift
let plugin: Plugin = try container.resolve(Plugin.self, tags: 1, Types.plugin) 
```

The tags weren't given in the same order as when the registration was made, but that makes no difference.

Tags become really powerful when resolving arrays of dependencies. In that case, only a subset of the tags needs to be specified. See the discussion on arrays in the resolution section of this README.

##### Arguments

It's very common to need to pass some state to a dependency when resolving. Guise supports up to 9 arguments.

```swift
class Service {
  let id: Int
  let state: String
}

container.register { _, id, state in
  Service(id: id, state: state)
}
```

When resolving these arguments must be given or Guise will throw an error:

```swift
let service: Service = try container.resolve(args: 1, "foo")
```

The error it throws is `.notFound`. This is because, as mentioned above, the arguments to the resolution block form part of the `Key` that uniquely identifies the registration. If they don't match, then
the registration cannot be found.

This means that registrations can be overloaded with different arguments:

```swift
container.register { _, state in
  Service(id: 0, state: state)
}
container.register { _, id, state in
  Service(id: id, state: state)
}
container.register { _, id in
  Service(id: id, state: "")
}
```

Each of the three registrations above is distinct.

##### Lifetimes

Guise supports two lifetimes: transient and singleton. Transient is the default.

In a transient registration, a new instance of the dependency is created and returned each time. In other words, the resolution factory that is passed as the last argument to `register` is called, the arguments are passed, and its result is returned to the caller.

In a singleton registration, the factory is invoked the first time, but every subsequent request for that registration returns the same instance.

```swift
container.register(lifetime: .singleton, instance: Service())
```

It's rare to register singletons with arguments, but if this is necessary, all resolutions of that singleton must pass the same arguments so that the registration can be located. (Here, "same" means the same types, not the same values.)

##### Transitive dependencies

One of the primary functions of dependency injection is to locate and resolve complex hierarchies of dependencies. Guise can do this as well. The first argument of every resolution block is an instance of `Resolver`, which allows registrations to be located and resolved.

```swift
class Database {}
class Service {
  let database: Database
  init(database: Database) {
    self.database = database
  }
}

container.register(lifetime: .singleton, instance: Database())
container.register(lifetime: .singleton) { r in
  Service(database: try r.resolve())
}
```

Whenever we resolve `Service`, the `Database` parameter in its constructor will be located and resolved.

This pattern is so common that Guise has a higher-order function, `auto`, that can handle up to 9 dependencies:

```swift
container.register(lifetime: .singleton, factory: auto(Service.init))
```

In order to use `auto`, the sub-dependencies must not have any tags or factory arguments.

#### Resolution

Resolution looks up and instantiates a dependency given its type, tags, and arguments, and taking into account its lifetime.

Resolution is simpler than registration, so a few examples will suffice:

```swift
class Service {}
container.register(instance: Service())

// Two alternate ways to resolve the above registration
let service: Service = try container.resolve()
let service = try container.resolve(Service.self)

container.register(tags: 2, instance: Service())
let service: Service = try container.resolve(tags: 2)

class Something {
  let id: Int

  init(id: Int) { self.id = id }
}

container.register { _, id in
  Something(id: id)
}
let something = try container.resolve(Something.self, args: 7)
```

##### Optional Resolution

Guise can resolve optionals as the wrapped type:

```swift
class Service {}
container.register(instance: Service())
let service: Service? = try container.resolve()
```

What happens behind the scenes is that Guise first looks for the exact registration, i.e., a registration of the type `Service?`. If it doesn't find that, then it attempts to resolve `Service`.

When resolving an optional, Guise returns `nil` instead of throwing an error if the registration cannot be found. To change this behavior, set `OptionalResolutionConfig.throwResolutionErrorWhenNotFound` to true.

##### Array Resolution

Imagine a plugin architecture in which we want to locate and resolve many instances of the same type.

```swift
protocol Plugin {}

container.register(Plugin.self, tags: UUID(), instance: Plugin1())
container.register(Plugin.self, tags: UUID(), instance: Plugin2())
container.register(Plugin.self, tags: UUID(), instance: Plugin3())
```

We can get all of these plugins very easily:

```swift
let plugins: [Plugin] = try container.resolve()
```

Just as with optional resolution, Guise first looks for an exact match for this registration. Not finding one, it notices that this is trying to resolve an array. It then locates all registrations of type `Plugin` and attempts to resolve them all. If any fail, all fail.

When resolving an array, tags are processed differently. Guise looks for all registrations containing all of the given tags.

```swift
container.register(Plugin.self, tags: "type1", UUID(), instance: Plugin1())
container.register(Plugin.self, tags: "type1", UUID(), instance: Plugin2())
container.register(Plugin.self, tags: "type2", UUID(), instance: Plugin3())
container.register(Plugin.self, tags: "type2", UUID(), instance: Plugin4())
```

Here we have four plugins registered. Each is disambiguated with an anonymous `UUID` and divided into two types: type 1 and type 2. To get all of the type 1 registrations…

```swift
let plugins: [Plugin] = try container.resolve(tags: "type1")
```

This gets `Plugin1` and `Plugin2` but not `Plugin3` and `Plugin4`. Of course, we can still get all four of them with this incantation:

```swift
let plugins: [Plugin] = try container.resolve()
```

If no registrations are found, Guise returns an empty array by default instead of throwing an error. To override this behavior, set `ArrayResolutionConfig.throwResolutionErrorWhenNotFound` to true.

##### Lazy Resolution

Occasionally there's a need to depend on a service that isn't ready yet. Or we wish to prevent a cycle because two services depend on each other.

One way to solve this problem is to pass an instance of the `Resolver` itself:

```swift
class Service {
  weak var resolver: Resolver! 

  init(resolver: Resolver) {
    self.resolver = resolver
  }

  func performService() throws {
    let database = try resolver.resolve(Database.self)
    database.doSomething()
  }
}
```

The problem with the pattern above is that it breaks one of the fundamental rules of dependency injection: make dependencies explicit. A user of `Service` must read the source code in order to know what other dependencies it has. This makes the class harder to use and harder to test.

Guise solves this problem with lazy resolvers. There are three lazy resolvers: `LazyResolver`, `LazyTagsResolver`, and `LazyFullResolver`. The difference between these is in how much of the registration information each one retains. `LazyFullResolver` stores the type, tags, and arguments. `LazyTagsResolver` stores the type and tags, and `LazyResolver` stores only the type. The additional information (if any) must be supplied when the `resolve` method is called.

```swift
class Service {}
container.register(tags: "s", instance: Service())

let lr: LazyResolver<Service> = try container.resolve()
```

Lazy resolvers don't have to be registered. Guise automatically constructs them as needed. This particular lazy resolver resolves dependencies of the type `Service`. Tags and arguments are specified when resolving:

```swift
let service = lr.resolve(tags: "s")
```

A `LazyTagsResolver` stores the type and tags, but not the arguments:

```swift
class Dependency {}
class Service {
  let lazyDependency: LazyTagsResolver<Dependency> 

  init(lazyDependency: LazyTagsResolver<Dependency>) { 
    self.lazyDependency = lazyDependency
  }

  func foo() throws {
    let dependency = try lazyDependency.resolve()
  }
}

container.register(tags: "d", lifetime: .singleton, instance: Dependency())
container.register { r in
  Service(dependency: try r.resolve(tags: "d"))
}
```

Notice that when resolving the `LazyTagsResolver`, it is resolved with `try r.resolve(tags: "d")`. When Guise constructs the `LazyTagsResolver`, it passes any tags used in `resolve` to the `LazyTagsResolver` and these tags are used when `LazyTagsResolver`'s `resolve` method is called. 

#### Async

Guise supports `async` registrations and resolution.

```swift
class Service {
  let database: Database

  init(database: Database) async {
    self.database = database
    await database.setup()
  }
}

container.register { r in
  try await Service(database: r.resolve())
}
let service = try await container.resolve(Service.self)
```

Any synchronous registration may be resolved asynchronously, but the reverse is not true. By default, if an attempt is made to resolve an `async` registration in a synchronous context, Guise throws `.requiresAsync`. This can be overridden by setting `Entry.allowSynchronousResolutionOfAsyncEntries` to true. Because this can briefly block threads in the `async` threadpool, there's a possibility of deadlocks. Whether this will actually occur in your application depends upon many factors. In a typical application, it's unlikely, but it's a possibility that must be considered. 

If you don't want to turn `allowSynchronousResolutionOfAsyncEntries` on, a safer pattern may be to use lazy resolution:

```swift
class Service {
  let databaseResolver: LazyFullResolver<Database>

  init(databaseResolver: LazyFullResolver<Database>) {
    self.databaseResolver = databaseResolver
  }

  func performService() async throws {
    let database = try await databaseResolver.resolve()
    await database.setup() 
  }
}

container.register(lifetime: .singleton) { _ async in
  await Database()
}
container.register(lifetime: .singleton, factory: auto(Service.init))
```