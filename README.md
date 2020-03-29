<!-- [![Build Status](https://travis-ci.org/Prosumma/Guise.svg)](https://travis-ci.org/Prosumma/Guise) -->
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Guise.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platforms](https://img.shields.io/cocoapods/p/Guise)
![License](https://img.shields.io/cocoapods/l/Guise)

> **Guise**, _n._ An external form, appearance, or manner of presentation, typically concealing the true nature of something.

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
- In keeping with its Swiftiness, Guise has a tiny, simple, extremely general core. Guise prefers higher-order functions and fluent interfaces over large numbers of overloads. This makes its API more composable and extensible.
- Many of these frameworks register _types_ directly. Guise registers _blocks_ directly and _types_ indirectly. This simple distinction removes an enormous amount of complexity while introducing greater compile-time safety. When combined with Swift's `@autoclosure` attribute, it makes registration elegant and minimal. (See the sections on transient and instance registration below.)
- Guise was designed to be simple rather than easy. Turns out it's both.

### Changes from previous versions

Guise 10 is a complete rewrite and reimagining based on conversations with developers using the product in real world applications. It is not backwards-compatible with previous versions.

- The `name` and `container` system of previous versions has been replaced with the powerful, hierarchical `Scope` system.
- Previous versions made heavy use of overloads. The number of overloads has been sharply reduced in favor of higher-order functions and fluent interfaces.
- The core has been rewritten with extreme simplicity in mind.
- The `Guise` type with its static methods is gone. You must now create an instance of a container yourself. Happily, the default container type
is still called `Guise`.

```swift
enum Name {
  case awesome
  case cool
}

class Dependency {}

Guise.register(instance: Dependency(), name: Name.awesome)

// Resolution
let dep: Dependency = Guise.resolve(name: Name.awesome)!
```

And in Guise 10:

```swift
enum Name {
  case awesome
  case cool
}

class Dependency {}

// We must create an instance of the container ourselves.
let container: Container = Guise()

// Registration uses a fluent interface.
container.in(.default / Name.awesome).singleton.register(factory: Dependency.init)

// There's a shorter form of this, too:
container.in(.default / Name.awesome).register(singleton: Dependency())

// Resolution
let dep: Dependency = container.resolve(in: .default / Name.awesome)!
```

A few more keystrokes, but the benefit is a simpler, more extensible, more powerful system. To understand why, read on.

### Scopes 

A `Guise` container is nothing more or less than a thread-safe mapping between keys and values. The entire edifice of Guise is built upon this simple foundation.

The values may be of any type, but the keys are always of type `Scope`. A `Scope` is a hierarchical value which consists of an identifier, which may be of any `Hashable` type, and an optional parent, which must also be a `Scope`:

```swift
let parent = Scope("parent")
let child = Scope("child", in: parent)
let grandchild = Scope("grandchild", in: child)
```

Creating scopes in this way is tedious, so the `/` operator has been overloaded to compose scopes together:

```swift
let parent = Scope("parent")
let child = parent / "child"
let grandchild = child / "grandchild"
```

Again, scopes can be nested to any level and any `Hashable` type may be used as an identifier:

```swift
let parent = Scope("parent")
let scope = parent / 7 / "whatever" / UUID()
```

In addition to `Hashable` types, any meta-type may also be used as a `Scope` identifier: 

```swift
let stringScope = Scope(String.self)
let strangeScope = stringScope / Int.self
```

Using `Scope`, we now have some potent abilities:

- We can identify registrations by their types.
- We can simulate containers using the scope hierarchy, without needing an explicit concept of nested containers.
- We can distinguish same-type registrations by name.

### Creating a Container

```swift
public typealias Container = Registrar & Resolver
```

Registration and resolution occur in a container. As mentioned previously, a container is simply a thread-safe key-value store mapping scopes to any value. 

```swift
let container: Container = Guise()
```

It is best to keep a global instance of the container somewhere. Where you keep this is up to you. 

### Registration 

Basic registration is straightforward:

```swift
container.register { _ in
  Dependency() 
}
```

The `_` parameter above is an instance of `Resolver`, which is actually the container itself. Since we don't need to use it here, we just use `_`.

If our dependency requires arguments, overloads exist:

```swift
container.register { (_, i: Int) in 
  Dependency(i)
}
```

If our dependency has sub-dependencies, we can use the resolver argument to resolve them:

```swift
container.register { r in
  Dependency(r.resolve()!)
}
```

All of the registrations above implicitly make _transient_ registrations. That is, each time we resolve one, the resolution block is called. Its value is never cached.

If the registered dependency takes no arguments, there is a convenient overload we may use:

```swift
container.register(transient: Dependency())
```

The argument to `register(transient:)` is an `@autoclosure`, so resolution still occurs lazily.

So far, Guise looks similar to its previous versions as well as other DI frameworks available for Swift and other platforms.

#### Registration in Scopes 


