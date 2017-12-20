
<!-- [![Build Status](https://travis-ci.org/Prosumma/Guise.svg)](https://travis-ci.org/Prosumma/Guise) -->
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Guise.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Language](https://img.shields.io/badge/Swift-4.0-orange.svg)](http://swift.org)
![Platforms](https://img.shields.io/cocoapods/p/Guise.svg)

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
- [x] Swift 4
- [x] Support for iOS 8.1+, macOS 10.9+, watchOS 2+, tvOS 9+

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

// Register a block directly.
Guise.register{ Something() }

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
Guise.register{ (resolver: Guising) in
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

### Mental Prerequisites

For the sake of brevity, this document assumes that you know what dependency resolution and injection are. It also assumes you have a strong knowledge of the Swift language. In particular: generics, blocks, autoclosures, the distinction between value and reference types, and the capture semantics of blocks.

### Usage Styles

Guise can be used in two different ways. The simplest way is to use the static methods of the `Guise` struct, and that is the approach taken here in this document.

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

#### Blocks
#### Caching
#### Factory
#### Instance
#### Weak
#### Names
#### Containers
#### Keys
#### Parameters
##### Guising Parameter
#### Init Injection
#### KeyPath Injection

### Resolution

#### Basics
#### Nil
#### Caching
#### Parameters
##### Guising Parameter (Reminder)
#### Lazy
##### Guising Parameter Doesn't Work With Lazy
#### KeyPath Injection

### Concurrency