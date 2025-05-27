# Guise 11

Guise is a flexible, minimal dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Supports `throw`ing, `async` and `MainActor`-isolated initializers and resolution
- [x] Simplifies unit testing
- [x] Pass arbitrary state when resolving
- [x] Lazy resolution
- [x] Nested containers
- [x] Swift 6+
- [x] Support for iOS 13+, macOS 10.15+, watchOS 6+, tvOS 13+

## What's New?

Support for Swift 6 concurrency, especially `MainActor`-isolated registrations and resolutions in a synchronous `MainActor`-isolated context. Read the section below on concurrency to understand the whys and wherefores of this.

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

### Concurrency

Guise has special support for `MainActor`-isolated registrations and resolutions. This uses the `isolation` parameter to distinguish between other overloads of `register` and `resolve`:

```swift
registrar.register(isolation: MainActor.shared) { _ in
  MyViewController()
}
let myViewController = try resolver.resolve(MyViewController.self, isolation: MainActor.shared)
```

The obvious question is: Why only support `MainActor`? Why not support any global actor? Well, actually Guise _does_ support any global actor, it's just that both registration and resolution must be `async`:

```swift
registrar.register { @MyActor _ async in
  MyService()
}
let myService: MyService = try await resolver.resolve()
```

The special support for `MainActor` is because, in general, we want `MainActor`-isolated resolutions _not_ to be `async` within the `MainActor` context, such as a view controller:

```swift
override func awakeFromNib() {
  super.awakeFromNib()
  MainActor.assumeIsolated {
    // Note that this is synchronous.
    let otherViewController = try resolver.resolve(OtherViewController.self, isolation: MainActor.shared)
  }
}
```

Currently, Apple does not provide a mechanism to "flow" the isolation context all the way through the internal dance of a DI framework, including type erasure, etc. while maintaining synchronous call semantics. I'm aware of `isolated` parameters and they looked promising. You _can_ flow the actor all the way through using that, but the problem is that when you try to resolve, everything is `async`, which kills ergonomics, particularly for `MainActor`. To call an actor-isolated method without using `await`, the Swift compiler must be able to prove statically _at compile time_ that the actor-isolated method is being called within
the very same isolation context.

I made the pragmatic choice to make `MainActor` a special case. And it really should be, because its semantics are a bit different from other actors. It's the actor within which all UI code executes, including a mountain of synchronous legacy code. As a result, we want resolution of `MainActor`-isolated types to be synchronous when possible. This greatly improves ergonomics.

As a matter of fact, you can resolve `MainActor`-isolated registrations in an `async` context if you wish. For example:

```swift
registrar.register(isolation: MainActor.shared) { _ in
  MyViewController()
}
let myViewController: MyViewController = try await resolver.resolve()
```

#### Why the `isolation` parameter instead of using a different name, like `registerMain`?

There are two imperfect reasons for this:

1. I wanted to stay consistent with using overloads of `register` and `resolve` for everything, whether synchronous, asynchronous, or `MainActor`-isolated.
2. If Swift ever does make it possible to flow the actor context through and preserve synchronous call semantics, this is the obvious syntax to use, so it's a bit of future-proofing.

If you think `register(isolation: MainActor.shared)` is long-winded, it's easy enough to create an extension method:

```swift
public extension Registrar {
  func registerMain<T, each Tag: Hashable & Sendable, each Arg: Sendable>(
    _ type: T.Type = T.self,
    tags: repeat each Tag,
    lifetime: Lifetime = .transient,
    factory: @escaping @MainActor @Sendable (any Resolver, repeat each Arg) throws -> T
  ) -> Key<T> {
    register(type, isolation: MainActor.shared, tags: repeat each tags, lifetime: lifetime, factory: factory)
  }
}
```

#### `mainauto`

Analogous to `auto`, Guise has a helper function called `mainauto` which can be used to simplify registration of `MainActor`-isolated types with constructor dependencies:

```swift
class MyViewController: UIViewController {
  let myService: MyService
  init(myService: MyService) {
    self.myService = myService
  }
}
await MainActor.run {
  registrar.register(isolation: MainActor.shared, factory: mainauto(MyViewController.init))
}
```

Why is `MainActor.run` necessary here? It really shouldn't be. Unfortunately, there's a bug in the Swift compiler's static concurrency analysis. It thinks that `MyViewController.init` &mdash; which is a `MainActor`-isolated initializer &mdash; is being called here instead of just passed as a higher-order function parameter. So unfortunately we must use `MainActor.run`. Hopefully this bug will be fixed in an upcoming version of Swift. If you don't use `mainauto`, you don't have to do this:

```swift
class MyViewController: UIViewController {
  let myService: MyService
  init(myService: MyService) {
    self.myService = myService
  }
}
registrar.register(isolation: MainActor.shared) { r in
  try MyViewController(myService: r.resolve())
}
```

#### The Resolution Matrix

Dependencies often depend on other dependencies. These dependencies may have differences in isolation, which can cause problems when resolving. For example:

```swift
// This type is MainActor-isolated
class ViewController: UIViewController {}
registrar.register(
  isolation: MainActor.shared,
  instance: ViewController()
)

// This type is non-isolated, which we call "sync" in Guise.
class Presenter {
  let vc: ViewController
  init(vc: ViewController) {
    self.vc = vc
  }
  @MainActor
  func present(on other: UIViewController) {
    other.present(vc, animated: true)
  }
}
// This won't even compile
registrar.register(factory: auto(Presenter.init))
```

The reason `Presenter`'s registration won't compile is because its dependency, `ViewController`, has a MainActor-isolated initializer, which must
be called within a `MainActor`-isolated context. There are several ways we can solve this.

First, we can use async registration:

```swift
registrar.register { r in
  try await Presenter(vc: r.resolve())
}
```

This works but kills ergonomics in many cases because now we must also resolve using `await`:

```swift
let presenter: Presenter = try await resolver.resolve()
```

The second solution is to make `Presenter`'s registration `MainActor`-isolated as well:

```swift
registrar.register(isolation: MainActor.shared, mainauto(Presenter.init))
```

But now we must always resolve in a `MainActor`-isolated context.

The best solution for this, in my opinion, is to use a `LazyResolver`. For that, we have to rewrite our `Presenter` a bit:

```swift
class Presenter {
  let lvc: LazyViewController
  init(lvc: LazyResolver<ViewController>) {
    self.lvc = lvc
  }
  @MainActor
  func present(on other: UIViewController) throws {
    let vc = try lvc.resolve(isolation: MainActor.shared)
    other.present(vc, animated: true)
  }
}
```

So what's the matrix? The matrix tells us what kind of resolution can resolve what kind of registration.

| RSLV :point_down: RGSTR :point_right: | Sync               | Async              | MainActor          |
|:--------------------------------------|--------------------|--------------------|--------------------|
| **Sync**                              | :white_check_mark: | :x:                | :x:                |  
| **Async**                             | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| **MainActor**                         | :white_check_mark: | :x:                | :white_check_mark: |

Across the top are the different kinds of registrations and along the side are the different kinds of resolutions. This tells us, for example, that a synchronous non-isolated ("sync") registration can be resolved by any kind of resolution. Asynchronous non-isolated ("async") resolution can resolve any kind of registration. And so on.

My recommendation is to use a `LazyResolver` everywhere you see an :x: in the table above.

### Assemblies

In a complex application with many modules, it can be helpful to organization registrations exported from the module. Guise provides _assemblies_ for this purpose.

```swift
class AwesomeAssembly: Assembly {
  func register(in registrar: any Registrar) {
    registrar.register(assemblies: CoolAssembly())
    registrar.register(lifetime: .singleton, instance: Service())
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
