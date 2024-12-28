# Guise 11

Guise is a flexible, minimal dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Supports `throw`ing and `async` initializers and resolution
- [x] Simplifies unit testing
- [x] Pass arbitrary state when resolving
- [x] Lazy resolution
- [x] Nested containers
- [x] Swift 6+
- [x] Support for iOS 13+, macOS 10.15+, watchOS 6+, tvOS 13+

## What Makes Guise Better Than Those Other Guys?

- Guise doesn't require any modification to the types you register. There are no special interfaces like `Injectable` or `Component` to implement. There are no special initializers or properties to add. Any type can be registered as is.
- Guise was designed with Swift in mind. Other DI frameworks for Swift appear to be translations of frameworks from other languages, particularly C&#x266f; and Java. These languages have strengths and weaknesses that are different from those of Swift, and those strengths and weaknesses are reflected in the design of these frameworks. This makes them clumsy in Swift.
- Many of these frameworks register _types_ directly. Guise registers _lambdas_ directly and _types_ indirectly (as the return type of the lambda). This simple distinction removes an enormous amount of complexity while introducing greater compile-time safety.
- Guise was designed to be simple rather than easy. Turns out it's both.

## Basic Documentation

### Registration

To register a dependency with the container, four facts are needed: The _type_ to be registered, the _tags_ under which it will be registered, the _arguments_ needed in order to resolve the registration, and the _lifetime_ of the registration. The first three uniquely identify a registration. We'll discuss the fourth fact, lifetime, below.

Let's start with these one by one.

#### Types

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

For simple registrations, Guise has a convenient overload which uses an `@autoclosure`:

```swift
container.register(instance: ConcreteService() as Service)
```

#### Tags

Tags can help locate, describe, and disambiguate registrations. A tag can be any type which is both `Hashable` and `Sendable`, such as `String`, `UUID`, `Int`
or a custom type you create yourself.

```swift
enum Types: Hashable, Sendable {
  case plugin
}

container.register(Plugin.self, tags: Types.plugin, 1, instance: PluginImpl1())
```

The order of tags is not important and any number may be used. Tags are collected into a `Set<AnySendableHashable>`, so repetition has no effect.

Because the tags used in a registration are part of the unique `Key` that identifies that registration, the same tags must be used when resolving:

```swift
let plugin: Plugin = try container.resolve(Plugin.self, tags: 1, Types.plugin) 
```

The tags weren't given in the same order as when the registration was made, but that makes no difference.

Tags become really powerful when resolving arrays of dependencies. In that case, only a subset of the tags needs to be specified. See the discussion on arrays in the resolution section of this README.

#### Arguments

It's very common to need to pass some state to a dependency when resolving. Guise supports any number of arguments.

```swift
class Service {
  let id: Int
  let state: String
}

container.register { _, id, state in
  Service(id: id, state: state)
}
```

When resolving, these arguments must be given or Guise will throw an error:

```swift
let service: Service = try container.resolve(args: 1, "foo")
```

#### Lifetimes

Guise supports two lifetimes: transient and singleton. Transient is the default.

In a transient registration, a new instance of the dependency is created and returned each time. In other words, the resolution factory that is passed as the last argument to `register` is called, the arguments are passed, and its result is returned to the caller.

In a singleton registration, the factory is invoked the first time, but every subsequent request for that registration returns the same instance.

```swift
container.register(lifetime: .singleton, instance: Service())
```

#### Transitive dependencies

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

This pattern is so common that Guise has a higher-order function, `auto`, that can handle any number of dependencies:

```swift
container.register(lifetime: .singleton, factory: auto(Service.init))
```

In order to use `auto`, the sub-dependencies must not have any tags or factory arguments.

### Resolution

Resolution looks up and instantiates a dependency given its type, tags, and factory arguments, and taking into account its lifetime.

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

#### Optional Resolution

Guise can resolve optionals as the wrapped type:

```swift
class Service {}
container.register(instance: Service())
let service: Service? = try container.resolve()
```

What happens behind the scenes is that Guise first looks for the exact registration, i.e., a registration of the type `Service?`. If it doesn't find that, then it attempts to resolve `Service`.

When resolving an optional, Guise returns `nil` instead of throwing an error if the registration cannot be found.

#### Array Resolution

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

If no registrations are found, Guise returns an empty array by default instead of throwing an error.

#### Lazy Resolution

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

Guise solves this problem with lazy resolvers.

```swift
class Service {}
container.register(tags: "s", instance: Service())

let lr: LazyResolver<Service> = try container.resolve()
```

Lazy resolvers don't have to be registered. Guise automatically constructs them as needed. A lazy resolver resolves dependencies of the type `Service`. Tags and arguments are specified when resolving:

```swift
let service = lr.resolve(tags: "s")
```

### Async

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

Any synchronous registration may be resolved asynchronously, but the reverse is not true. By default, if an attempt is made to resolve an `async` registration in a synchronous context, Guise throws `.requiresAsync`.

### Assemblies

In a complex application with many modules, it can be helpful to organization registrations exported from the module. Guise provides _assemblies_ for this purpose.

```swift
class AwesomeAssembly: Assembly {
  func register(in registrar: any Registrar) {
    registrar.register(assemblies: CoolAssembly())
    registrar.register(lifetime: .singleton: instance: Service())
  }

  // This method is optional. A default implementation
  // is provided, which does nothing.
  func registered(to resolver: any Resolver) {
    do {
      let service = try resolver.resolve(Service.self)
      service.configure()
    } catch {
      // Handle error
    }
  }
}
```

Assemblies are organized in a hierarchy. An assembly should register its dependent assemblies using `register(assemblies:)`.

Assemblies are keyed by their type, so adding the same assembly twice will not result in double registration.

The act of assembling first creates an ordered set of assemblies, i.e., a list without duplicates in order of first registration. It then iterates through this list and calls `register(in:)` on each one. After which it iterates through the list and calls `registered(to:)` on each one.

The purpose of `registered(to:)` is to perform additional initialization after dependencies have been registered without exposing the dependencies outside of the assembly.

Once all dependencies have been registered, call `assemble` on the container to make everything work. Additional assemblies can be passed as arguments to `assemble` or it can be called without arguments if they've already been registered.

```swift
container.assemble(AwesomeAssembly(), CoolAssembly())
```

or

```swift
container.register(assemblies: AwesomeAssembly(), CoolAssembly())
container.assemble()
```

### Nested Containers

Guise supports nested `Container`s. When constructing a `Container`, simply pass its parent in the constructor:

```swift
let parent = Container()
let child = Container(parent: parent)
```

When resolving, if an entry can't be found in the child, the parent is searched. Child entries always override parent entries for matching `Key`s. The reverse is **not** true: A parent has no knowledge of its child containers. Searching the parent directly will not discover any child entries.

### Nested Containers &amp; Assemblies

Assemblies are simply a way to make many registrations _en masse_. If a container cannot find a registration, it will search its parent. This is not true of assemblies. Assemblies are specific to a container.

```swift
let parent = Container()
parent.assemble(CoolAssembly())
let child = Container(parent: parent)
child.assemble(AwesomeAssembly())
```
