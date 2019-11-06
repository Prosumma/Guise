<!-- [![Build Status](https://travis-ci.org/Prosumma/Guise.svg)](https://travis-ci.org/Prosumma/Guise) -->
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Guise.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platforms](https://img.shields.io/cocoapods/p/Guise)
![License](https://img.shields.io/cocoapods/l/Guise)

Guise is an elegant, flexible, type-safe dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Simplifies unit testing
- [x] Support for containers, named dependencies, and arbitrary types
- [x] Pass arbitrary state when resolving
- [x] Typesafe `KeyPath` injection
- [x] Lazy resolution
- [x] Support for arbitrary metadata
- [x] Swift 5.x (for Swift 4.x use v8.0)
- [x] Support for iOS 8.0+, macOS 10.9+, watchOS 2+, tvOS 9+

### What Makes Guise Better Than Those Other Guys?

- Guise doesn't require any modification to the types you register. There are no special interfaces like `Injectable` or `Component` to implement. There are no special initializers or properties to add. Any type can be registered as is.
- Guise was designed with Swift in mind. Other DI frameworks for Swift appear to be translations of frameworks from other languages, particularly C&#x266f; and Java. These languages have strengths and weaknesses that are different from those of Swift, and those strengths and weaknesses are reflected in the design of these frameworks. This makes them clumsy in Swift.
- Many of these frameworks register _types_ directly. Guise registers _blocks_ directly and _types_ indirectly. This simple distinction removes an enormous amount of complexity while introducing greater compile-time safety. When combined with Swift's `@autoclosure` attribute, it makes registration elegant and minimal. (See the sections on factory and instance registration below.)
- Guise was designed to be simple rather than easy. Turns out it's both.

### Showcase

Here's a quick taste of what Guise can do and how it does it.

#### Registration

```swift
// The `factory` parameter is an @autoclosure.
Guise.register(factory: Implementation() as Plugin)

// The `instance` parameter is also an @autoclosure. Guise is lazy wherever possible.
Guise.register(instance: Singleton() as Service)

// Register a block directly and parameterize it.
Guise.register{ (x: Int) in Something(x: x) }

// Use a name to disambiguate registrations. (Otherwise the last one wins.)
// A name can be any `Hashable` type.
Guise.register(factory: Implementation1() as Plugin, name: Name.implementation1)
Guise.register(factory: Implementation2() as Plugin, name: Name.implementation2)

class Controller {
  var service: Service!

  init(something: Something, plugin: Plugin) {
    // blah blah
  }
}

// Initializer injection
Guise.register{ (resolver: Resolving) in
  // The types of the parameters determine what is resolved.
  return Controller(something: resolver.resolve()!, plugin: resolver.resolve(name: Name.implementation2)!)
}

// Register Controller's `service` property for injection.
Guise.into(injectable: Controller.self).inject(\.service).register()
```

#### Resolution

```swift
// Use the many overloads of `resolve` to resolve dependencies.
let plugin1 = Guise.resolve(type: Plugin.self, name: Name.implementation1)!
let plugin2: Plugin = Guise.resolve(name: Name.implementation2)!

let controller = Guise.resolve()! as Controller
// Resolve KeyPath injections
Guise.resolve(into: controller)
```

### Important Change

Guise 9.1 introduces support for Swift Package Manager.

### Mental Prerequisites

For the sake of brevity, this document assumes that you know what dependency resolution and injection are. It also assumes you have a strong knowledge of the Swift language. In particular: generics, blocks, autoclosures, the distinction between value and reference types, and the capture semantics of blocks.

### Usage Styles

Guise can be used in two different ways. The simplest way is to use the static methods of the `Guise` type, and that is the approach taken here in this document.

The other way is to create an instance of the `Resolver` class and use its instance methods. For instance, one can say:

```swift
Guise.register{ Plink() }
```

Or one can say,

```swift
let resolver = Resolver()
resolver.register { Plink() }
```

### Registration

Registration is the act of telling Guise how to create or locate a dependency. There are many ways to do this, but we will cover the four most important.

#### Factory Registration

In factory registration, we tell Guise that when resolving, we always want a _new_ instance of whatever we have registered.

```swift
Guise.register(factory: StringFormatter())
```

The `factory` parameter is an `@autoclosure`, so it is evaluated lazily. Actually, because an `@autoclosure` is a block, it is simply stored for later execution and called every time we ask Guise for a `StringFormatter`:

```swift
let formatter: StringFormatter = Guise.resolve()!
```

#### Instance Registration

In instance registration, we tell Guise that when resolving, we always want the _same_ instance of whatever we have registered.

```swift
Guise.register(instance: Api())
```

The `instance` parameter is an `@autoclosure`, so it is also stored for later evaluation. However, it is called only once, the first time we ask Guise for an `Api` instance. After that, the same instance is returned.

If the registered type is a reference type, Guise will hand us the same reference back. If it's a value type, we'll get a copy, but the initializer will not be called again.

Effectively, instance registration creates a singleton within the resolver.

#### Block Registration

Block registration is the foundation upon which all other types of registration are built. However, it has a clumsier syntax than the other forms of registration, so it should be avoided except in special cases.

Block registration is useful if you need to pass a parameter when resolving or if you wish to perform more complex logic when resolving.

```swift
Guise.register{ (x: Int) in Something(x: x) }
let something: Something = Guise.resolve(parameter: 3)!
```

The registration block can take zero or one parameters. If the need arises to pass more complex state to the registration block, use a structured type such as a struct, tuple, or enum.

If the single parameter to the block is of type `Resolving`, the resolver will be automatically passed to the block when resolving. It is not necessary to pass it explicitly.

```swift
Guise.register{ (resolver: Resolving) in
  Api(database: resolver.resolve()!)
}
let api = Guise.resolve()!
```

When `let api = Guise.resolve()!` is called, the current resolver is automatically passed into the `resolver` parameter of the block.

#### Weak Registration

When caching, Guise always holds a strong reference to whatever is being cached. Because the Guise resolver typically lives for the entire lifetime of the application, this can be problematic when registering transient entities such as view controllers.

The solution is weak registration. Unlike the other forms of registration, the `weak:` parameter is _not_ an `@autoclosure`.

```swift
class MyViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    Guise.register(weak: self)
  }
}
```

Here we are weakly registering an instance of `MyViewController` with Guise. Never force-unwrap when resolving a weak reference:

```swift
guard let myViewController: MyViewController = Guise.resolve() else {
  return
}
```

### Abstraction

> **Guise**, _n._ An external form, appearance, or manner of presentation, typically concealing the true nature of something.

One of the functions of a dependency resolver is to locate dependencies. Another one is to abstract them so that they can be replaced with alternate implementations, whether in unit testing or elsewhere. This is typically achieved with a protocol.

```swift
protocol DatabaseLayer {
  func retrieveSomething() -> [Something]
}

class Database: DatabaseLayer {
  func retrieveSomething() -> [Something] {
    return connection.retrieve("SELECT * FROM something")
  }
}

Guise.register(instance: Database() as DatabaseLayer)
```

The magic here is `as DatabaseLayer`. This makes the registered type `DatabaseLayer` instead of `Database`. When resolving this registration, we must ask for a `DatabaseLayer`, _not_ a `Database`.

```swift
let database: DatabaseLayer = Guise.resolve()!
```

Since we don't want to talk to a real database in a unit test, we can now use a different implementation of `DatabaseLayer` in our unit tests.

### Names

If we register the same type twice with Guise, the second registration silently clobbers the first.

```swift
Guise.register(instance: Database() as DatabaseLayer)
Guise.register(instance: FakeDatabase() as DatabaseLayer)
```

Because these both register `DatabaseLayer`, the second one overwrites the first one. To disambiguate these, we can use a name.

```swift
enum Name {
  case real
  case fake
}

Guise.register(instance: Database() as DatabaseLayer, name: Name.real)
Guise.register(instance: FakeDatabase() as DatabaseLayer, name: Name.fake)
```

Any `Hashable` type—including `String`—can be used as a name. I recommend using an enumeration value.

When resolving, the name must be passed or the registration will not be found.

```swift
let database: DatabaseLayer = Guise.resolve(name: Name.real)!
```

### Containers

Containers allow registrations to be grouped together. A container is just another kind of name, and like a name it can be any `Hashable` type.

```swift
enum Container {
  case plugins
}

Guise.register(factory: Plugin1() as Plugin, name: Plugin.plugin1, container: Container.plugins)
Guise.register(factory: Plugin2() as Plugin, name: Plugin.plugin2, container: Container.plugins)
Guise.register(factory: Plugin3() as Plugin, name: Plugin.plugin3, container: Container.plugins)
```

Here we are making three `Plugin` registrations, each with a different implementation. They are disambiguated with a name and placed in `Container.plugins`.

When resolving a registration made in a container, the container must be mentioned or the registration will not be found.

```swift
let plugin: Plugin = Guise.resolve(name: Plugin.plugin1, container: Container.plugins)!
```

While containers can be used for any purpose you wish, their primary purpose is to allow a group of registrations to be dropped _en masse_.

```swift
Guise.unregister(container: Container.plugins)
```

### Keys

All of the `register` overloads return an instance of `Key<RegisteredType>`. The registered type is the return type of the registration block. The other elements of a key are the registered name and the registered container. All registrations have a name and a container, even if not explicitly mentioned. The default name is `Guise.Name.default`. The default container is `Guise.Container.default`.

It is the combination of registered type, name, and container that create a key and make a registration unique. No other information—caching, metadata, `register` overload used—has any effect on this.

```swift
Guise.register(instance: Foo())
Guise.register(factory: Foo())
```

Because the above two registrations register the same type with the same name in the same container, the second one silently overwrites the first.

Keys can be used to resolve or drop registrations, filter them, etc. In most cases, it is not necessary to save registration keys, because they can easily be constructed at any time.

```swift
let key = Key<Plugin>(name: Plugin.plugin1, container: Container.plugins)
```

Keys come in two varieties: `Key<RegisteredType>` and `AnyKey`. The former is the most common. The latter is type-erased but still contains an internal reference to the registered type. It is used when heterogeneous lists of keys are needed.

### Resolving

Many examples of resolving have already been seen. Resolving is inherently simpler than registration.

The `resolve` overloads return `nil` if the registration could not be found. This includes weak registrations that have been zeroed. If your program is invalid without the dependency having already been registered, you should force-unwrap when resolving.

```swift
let database: DatabaseLayer = Guise.resolve()!
```

This is the most common case. However, if the registration is only optionally registered or if it is a weak registration, the registration should be checked for `nil` before it is used.

```swift
if let logger: XCGLogger = Guise.resolve() {
  logger.error("Something bad happened.")
}
```

### Caching

Guise has the ability to cache the result of calling the resolution block and simply reusing it later rather than calling the block again. Some `register` overloads offer a `cached:` parameter that allows the user to choose whether caching should be performed or not. Others are implicitly always cached or never cached.

All of the `resolve` overloads offer a `cached:` parameter that allows the caller to override the caching decision made when the registration was created. However, this parameter is only honored for those `register` overloads that have an explicit `cached:` parameter. (This is a breaking change from previous versions of Guise where caching could always be overridden when resolving.)

What this means is that factory registration is _always_ uncached, and instance and weak registration are _always_ cached.

```swift
Guise.register(instance: Singleton())
let singleton: Singleton = Guise.resolve(cached: false)!
```

In the example above, the `cached` parameter is ignored because `register(instance:)` does not allow registrations to be uncached.

```swift
Guise.register(cached: true) { Singleton() }
let singleton: Singleton = Guise.resolve(cached: false)!
```

In this example, block registration allows the registrar to decide explicitly whether caching should be performed or not, so it can be overridden. In the second line, the resolution block will be called again, even if a cached instance already exists.

### Initializer Injection

One of the most important capabilities of a dependency resolver is to compose dependencies together. The easiest and most straightforward way to do this is with initializer injection. In this pattern, the dependencies of a dependency are injected into its initializer at the time it is registered.

```swift
struct Api {
  init(database: DatabaseLayer) {}
}

Guise.register(instance: Database() as DatabaseLayer)
Guise.register(instance: Api(database: Guise.resolve()!))
```

### Metadata

Arbitrary metadata can be attached to any registration. This metadata can be of any type.

```swift
Guise.register(factory: Plugin1() as Plugin, metadata: PluginMetadata(granularity: 4))
```

Metadata is chiefly useful in filtering. It allows the caller to locate a registration without instantiating it. Imagine an application with a large set of plugins that are expensive to instantiate, perhaps because they hold and manipulate external resources. We want the ability to locate a plugin and query its capabilities before we decide whether to instatiate it or not. This is what metadata allows us to do.

For more information, see the section on Filtering.

### Filtering

Filtering locates registrations using various criteria but does not resolve them.

```swift
let pluginRegistrations = Guise.filter(type: Plugin.self, container: Container.plugins)
```

This filter locates all registrations of type `Plugin` in `Container.plugins`, regardless of name. The return type of most filter methods is `[Keyed: Registration]`, where `Keyed` is either `Key<RegisteredType>` or `AnyKey`.

Although the `filter` overloads return `Registration` instances directly, it is best not to try to resolve using these. Instead, pass the keys to one of the `resolve` overloads that takes one or more keys.

```swift
let plugins = Guise.resolve(keys: pluginRegistrations.keys)
```

In addition to type, name, and container, metadata can be queried.

```swift
let pluginRegistrations = Guise.filter(type: Plugin.self, container: Container.plugins) { (metadata: PluginMetadata)
  metadata.granularity > 2
}
```

This returns all registrations of type `Plugin` in `Container.plugins` whose metadata is of type `PluginMetadata` and whose "granularity" is greater than 2.

If the metadata implements `Equatable` and an equality comparison is desired, a convenient overload exists.

```swift
let pluginRegistrations = Guise.filter(type: Plugin.self, container: Container.plugins, metadata: PluginMetadata(granularity: 2))
```

This returns all registrations of type `Plugin` in `Container.plugins` whose metadata == `PluginMetadata(granularity: 2)`.

### `KeyPath` Injection

Whenever possible, dependencies should be injected using initializer injection, as described above. However, sometimes we don't have control over the instantiation of a type. This is particularly true of view controllers instantiated from storyboards, etc.

In this case, Guise offers a powerful technique called `KeyPath` injection. The first step in `KeyPath` injection is to specify the dependencies as properties on the type into which they should be injected.

```swift
class MyViewController: UIViewController {
  var api: Api!
  var database: DatabaseLayer!
}
```

Because these dependencies are resolved after `MyViewController` has already been instantiated, they should be optionals, as shown here.

These properties _cannot_ be private. Otherwise, Swift will not generate `KeyPath` constants for these in the correct scope and Guise will not be able to locate them. Dependencies should be explicit anyways, either exposed as parameters in the initializer or as properties on the type that depends upon them.

The next step in `KeyPath` injection is to register some dependencies so that they can be resolved.

```swift
Guise.register(instance: Database() as DatabaseLayer)
Guise.register(instance: Api(database: Guise.resolve()!))
```

The best place to do this in the `AppDelegate` before the rest of the application has been loaded.

Next, we tell Guise how to marry the properties of `MyViewController` to the registered dependencies. Swift's type system is a big help here, because keypaths are type-safe.

```swift
Guise.into(injectable: MyViewController.self).inject(\.api).inject(\.database).register()
```

In plain English, this says, "For the type `MyViewController`, the `api` property and the `database` property are satisfied by registrations of the corresponding types." In other words, because the `\MyViewController.api` `KeyPath` is of type `KeyPath<MyViewController, Api>`, it can be resolved by locating a registration of type `Api`.

The last step is to resolve the injections.

```swift
class MyViewController: UIViewController {
  // These two ivars are "hydrated" by Guise.resolve(into:).
  var api: Api!
  var database: DatabaseLayer!

  override func viewDidLoad() {
    super.viewDidLoad()
    // This line gives values to the api and database ivars above.
    Guise.resolve(into: self)
  }
}
```

The line `Guise.resolve(into: self)` provides values for the `api` and `database` properties of `MyViewController`.

#### Abstraction

A best practice when using `KeyPath` injection is to create a protocol that holds the property to be injected rather than using a concrete type. Since `KeyPath` injection works only with reference types, the protocol must be marked as a reference type as well, using `: class`.

```swift
protocol UsesApi: class {
  var api: Api! { get set }
}

protocol UsesDatabaseLayer: class {
  var database: DatabaseLayer! { get set }
}

class MyViewController: UIViewController, UsesApi, UsesDatabaseLayer {
  var api: Api!
  var database: DatabaseLayer!
  override func viewDidLoad() {
    super.viewDidLoad()
    Guise.resolve(into: self)
  }
}

class AppDelegate {
  func applicationDidFinishLaunching() {
    Guise.register(instance: Database() as DatabaseLayer)
    Guise.register(instance: Api(database: Guise.resolve()!))
    // Without ": class" on the protocols above, the following two lines
    // will not compile.
    Guise.into(UsesApi.self).inject(\.api).register()
    Guise.into(UsesDatabaseLayer.self).inject(\.database).register()
  }
}
```

Because `MyViewController` implements `UsesApi` and `UsesDatabaseLayer`, its dependencies will be properly resolved when `resolve(into:)` is called.

#### Names and Containers

Injections support names and containers.

```swift
Guise.register(instance: Database() as DatabaseLayer, name: Name.real)
Guise.into(injectable: UsesDatabase.self).inject(\.database, name: Name.real).register()
```

This says that when satisfying the `database` dependency of `UsesDatabase`, the registration with the name `Name.real` must be used.

#### Explicit Injection

Just as ordinary registrations are blocks under the hood, so are `KeyPath` injections. It is possible to perform an injection using a block.

```swift
protocol Arbiter {
  var rank: Int { get }
  var judge: Judge? { get set }
}

Guise.into(injectable: Arbiter.self).inject { (target, resolver) in
  if target.rank < 7 { return target }
  target.judge = resolver.resolve()
  return target
}
```

An explicit injection is passed two parameters. The first is an instance of the target type itself, i.e., `target` is an instance of `Arbiter`. The second parameter is the current resolver. _An injection block must **always** return its target._ If it is a reference type, the same reference must be returned. You must not create a new instance of this type. No such restriction exists for value types, although an instance of the same type must be returned. In addition, it is highly advisable, although not absolutely required, to resolve any dependencies using the passed-in resolver and not some external resolver.

#### Neutering Guise

Using `Guise.resolve(into:)` is mildly problematic. Here we have an explicit reference to Guise inside one of our types. This is best avoided because it creates a dependency on the resolver itself. What if we want to use Guise in our application but not in our unit tests? The way out is to use the `ImpotentResolver`.

```swift
// Somewhere in our unit tests, before they run.
Guise.resolver = ImpotentResolver()
```

Here we replace Guise's default resolver with the `ImpotentResolver`. The `ImpotentResolver` does nothing. All registrations are ignored. All resolutions return `nil`. `resolve(into:)` does nothing. We must now set our dependencies explicitly when unit testing this controller.

```swift
let controller = MyViewController()
controller.database = FakeDatabase()
controller.api = Api(database: controller.database)
_ = controller.view
```

When `controller.view` is called, `viewDidLoad` is implicitly called, but because we're using the `ImpotentResolver`, `Guise.resolve(into: self)` has become a no-op.

### Advanced Guise

Guise is a powerful framework with many features. Not all of these have been discussed here. Look at the code and the unit tests to see more. Guise was designed to be simple rather than easy. It is a fairly low-level framework designed to be the base upon which other frameworks can be built. For instance, I plan to create a UI framework with custom segues and so on that allow dependencies to be resolved in view controllers without having to explicitly call `Guise.resolve(into:)`. The creation of such a framework is outside of the scope of Guise but will require Guise under the hood to do its work. I'm a busy guy, so don't look for this framework any time soon. 😀

Guise was also designed to be extensible. Look at the code and you'll see that each piece was built up from much simpler pieces. I've provided a large number of useful overloads, but create your own extensions as you see fit.

## Other Frameworks

I have a few other frameworks that may be of use to you.

### [Core Data Query Interface](https://github.com/prosumma/CoreDataQueryInterface)

CDQI allows Core Data queries to be expressed in a very succinct manner using a fluent syntax.

```swift
let isabellas =
  try! moc
    .from(User.self)
    .filter(User.e.firstName == "Isabella")
    .orderDesc(by: User.e.lastName)
    .all()
```

### [DateMath](https://github.com/prosumma/DateMath)

DateMath is a tiny framework that allows date math to be performed using `Calendar.Component` values.

```swift
let today = Date()
let tomorrow = today + .day * 1
```

The time zone in which the calculations are performed can be specified.

```swift
let today = Date()
let oneDayLessOneSecondInGMT = TimeZone(identifier: "GMT")! ⁝ today + .day * 1 - .second * 1
```

### [AbsoluteDate](https://github.com/prosumma/AbsoluteDate)

Swift's `Date` type represents a specific point in time independent of time zone. An `AbsoluteDate`, by contrast, is like the date representations available in many databases: It wraps the human-readable string representation but does so without time zone, so the exact point in time is unknown.

AbsoluteDate depends on the DateMath framework. Date math can be performed on `AbsoluteDate`, `AbsoluteTime`, and `AbsoluteDay` instances.
