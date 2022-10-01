# Guise 10

Guise is an elegant, flexible, type-safe dependency resolution framework for Swift.

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

To register a dependency with the container, four facts are needed: The _type_ to be registered, the _tags_ under which it will be registered, the _arguments_ needed in order to resolve the registration, and the _lifetime_ of the registration. Let's start with these one by one.

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