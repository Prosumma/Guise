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

Guise 9:

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

All registrations occur in a `Scope`, even if it is not explicitly mentioned. The default scope for registrations is `Scope.default`. (This is not a root scope. It actually has a parent, `Scope.factories`. More on that later.)

When we say that a registration occurs "in a `Scope`", we mean that a registration always has a parent scope. When a registration occurs, the type of the registered dependency is combined with the scope in which it is registered to produce the key with which the registration is recorded in the container. 

```swift
let key: Scope = container.register(transient: Dependency())
```

The `key` above is `Scope.default / Dependency.self`. When a `Scope` is used in this way, we call it a `Key`.

```swift
public typealias Key = Scope
```

We can make registrations in a `Scope` of our choice using the `in` function of the fluent interface:

```swift
extension Scope {
  static let plugins = .factories / UUID()
}

let key = container.in(.plugins).register(transient: Plugin1() as Plugin) 
```

Our `key` is thus `Scope.plugins / Plugin.self`.

We can use this technique to distinguish multiple registrations which would otherwise overwrite each other:

```swift
container.in(.plugins / UUID()).register(transient: Plugin1() as Plugin)
container.in(.plugins / UUID()).register(transient: Plugin2() as Plugin)
container.in(.plugins / UUID()).register(transient: Plugin3() as Plugin)
```

When resolving, we can easily find all the factory registrations in `Scope.plugins` that are of type `Plugin`, even if we don't know the exact key:

```swift
let plugins: [Key: Plugin] = container.factories(key(type: Plugin.self) && scope(.plugins)).resolve()
```

More on this and what it all means when we discuss resolution.

#### Lifetimes 

Factory registrations have four possible lifetimes, described by the `Lifetime` type:

- `Lifetime.transient`: The registered block is executed every time resolution occurs.
- `Lifetime.singleton`: The registered block is called only once. After that, its result is cached and returned as is.
- `Lifetime.weak`: Same as `Lifetime.singleton`, except that a `weak` reference is held to the resolved value. When all references have gone out of scope, resolution will always return `nil`. Applies only to reference types.
- `Lifetime.once`: The registered block is called only once. After that, it always returns `nil`.

The `Lifetime` system is extensible.

Lifetimes are specified using the `lifetime` function in the fluent interface. 

```swift
container.lifetime(.singleton).register { _ in
  Dependency()
}
```

Each of the four pre-defined lifetimes also has a property of its own in the fluent interface:

```swift
container.singleton.register { _ in Dependency() }
container.transient.register { _ in Dependency() }
```

In addition, as mentioned previously, there are overloads of `register` which include the lifetime:

```swift
container.register(transient: Dependency())
```

When multiple lifetimes are specified, the last one wins:

```swift
container.singleton.transient.register { _ in
  Dependency()
}
```

In the above case, `singleton` is superfluous and the expression registers a `transient` dependency.