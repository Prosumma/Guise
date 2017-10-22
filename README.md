<h1 style='text-align: center'>Guise</h1>

<!-- [![Build Status](https://travis-ci.org/Prosumma/Guise.svg)](https://travis-ci.org/Prosumma/Guise) -->
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Guise.svg)](https://cocoapods.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Language](https://img.shields.io/badge/Swift-3.0-orange.svg)](http://swift.org)
![Platforms](https://img.shields.io/cocoapods/p/Guise.svg)

Guise is an elegant, flexible, type-safe dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Simplifies unit testing
- [x] Support for containers, named dependencies, and arbitrary types
- [x] Pass arbitrary state when resolving
- [x] Support for arbitrary metadata
- [x] Swift 4
- [x] Support for iOS 8.1+, macOS 10.9+, watchOS 2+, tvOS 9+

### Prerequisites

Dependency resolution is a somewhat advanced topic. For the sake of brevity, this document assumes that you know what dependency resolution and injection are. It also assumes you have a strong knowledge of the Swift language, including generics, blocks, and the distinction between value and reference types.

### Registration Basics

Before a dependency can be resolved, it must first be registered. Guise does not register dependencies directly. Instead, it registers a block&mdash;called the _resolution block_&mdash;that returns the desired dependency.

```swift
_ = Guise.register{ Plink() }
```

(The `register` overloads return an instance of `Key<T>`. More on that later.)

The return type of the resolution block is called the _registered type_. When we ask Guise to resolve this dependency, we use the registered type to do so:

```swift
let plink = Guise.resolve(type: Plink.self)!
```

All of the `resolve` overloads return `T?`, where `T` is the registered type. If the registration is not found, `nil` is returned. In this case, we're very sure we have registered `Plink`, so we force-unwrap it.

### Abstraction

Registering concrete types defeats the purpose of dependency resolution. In general, we want the registered type to be an abstraction such as a protocol or base class so that we can vary the implementation based on factors such as whether the code is executing in `DEBUG` mode or in a unit test and so on.

Consider the following:

```swift
protocol Plonk {
  func plonk()
}

class Plink: Plonk {
  func plonk() {
    print("plonk")
  }
}

class DebugPlink: Plonk {
  func plonk() {
    print("DEBUG: plonk")
  }
}

#if DEBUG
  _ = Guise.register{ DebugPlink() as Plonk }
#else
  _ = Guise.register{ Plink() as Plonk }
#endif
```

Remember: The return type of the resolution block is the registered type. In this case, the registered type is not `DebugPlink` or `Plink`, it's `Plonk`:

```swift
let plonk: Plonk = Guise.resolve()!
```

Depending upon whether the `DEBUG` flag is set, the `Plonk` we get will either be a `DebugPlink` or a `Plink`.

### Caching

In many cases, we don't want the resolution block to be called over and over again. Once it's been evaluated, we want Guise to cache the result and just return it every time, effectively creating a singleton. This is achieved as follows:

```swift
_ = Guise.register(cached: true) { Plink() as Plonk }
```

Guise will evaluate the resolution block the first time, but after that it will return the cached value. The semantics of returning the cached value vary depending upon whether the cached value is a value type or a reference type. This is a feature of the Swift language and has nothing directly to do with Guise. If the cached value is a reference type, you will get a reference to it. If it's a value type, you'll get a copy, but its initializer will not be called again.

When resolving, it is possible to override the registered caching behavior by passing an explicit value for the `cached` parameter, e.g.,

```swift
let plonk = Guise.resolve(cached: false)! as Plonk
```

By passing `cached: false`, we are telling Guise to call the resolution block again and return its value. (Any previously cached value will _not_ be overwritten.)

Similarly…

```swift
let plonk = Guise.resolve(cached: true)! as Plonk
```

By passing `cached: true`, we are telling Guise to use any previously cached value. If there is no cached value, Guise will call the resolution block and cache it, using it whenever `cached: true` is called again.

### Factory Registration

One of the most common cases in dependency resolution is to register a factory from which many distinct instances of the same type will be created. Guise has a clever overload of `register` to handle this.

```swift
_ = Guise.register(factory: Plink() as Plonk)
```

Before explaining this, it will be helpful to give the type of the `factory` parameter: `@escaping @autoclosure () -> T`. This means that `Plink() as Plonk` is not evaluated at the call site, but is actually a block that is saved for later execution. The code above is exactly equivalent to…

```swift
_ = Guise.register(cached: false) { Plink() as Plonk }
```

(`cached: false` is the default. We could have omitted it, but stating it this way makes it clearer.)

### Instance Registration

Instance registration is analogous to factory registration, except that the result of the resolution block is always cached.

```swift
_ = Guise.register(instance: Plink() as Plonk)
```

Again, this is exactly equivalent to…

```swift
_ = Guise.register(cached: true) { Plink() as Plonk }
```

The `instance` parameter's type signature is exactly the same as that of `factory` above.

### Named Registrations

A registration that registers the same type as a previous registration silently overwrites that registration, e.g.,

```swift
_ = Guise.register(instance: DebugPlink() as Plonk)
_ = Guise.register(instance: Plink() as Plonk)
```

The registration of `DebugPlink` as a `Plonk` is obliterated by the line that comes after it. So how can multiple `Plonk` registrations be made? By naming them:

```swift
_ = Guise.register(instance: DebugPlink() as Plonk, name: "debug")
_ = Guise.register(instance: Plink() as Plonk)
```

The first registration is given the name "debug", while the second one is not explicitly given a name. (It turns out it does indeed have a name, but more on that in a moment.) Because each registration has a different name, they are different registrations.

When resolving, the appropriate name must be passed:

```swift
let debugPlonk: Plonk = Guise.resolve(name: "debug")!
```

Strings, however, are not the best names. It turns out that any `Hashable` type can be used as a name. Simple enumerations in Swift are `Hashable` by default and I strongly recommend their use for names in Guise. In fact, the default name for a registration is `Guise.Name.default`.

It is the combination of registered type and name that disambiguates a registration. If disparate types are registered with the same name, they are separate registrations, e.g.,

```swift
_ = Guise.register(factory: Foo(), name: Name.foo)
_ = Guise.register(factory: Bar(), name: Name.foo)
```

Both of these registrations are made with the name `Name.foo`, but because they register different types, they are different registrations.

### Containers

In addition to names, registrations can be made in containers. A container is a group of related registrations. How they are related is up to you, but a common use case might be a set of plugins. The advantage of a container is that it can be easy to unregister all of the registrations in a container at once. (More on that later.)

```swift
_ = Guise.register(factory: Plink(), container: Container.plinks)
```

A container is just another name and any `Hashable` type can be used here. Enumerations are strongly recommended. The default container, which never needs to be specified, is `Guise.Container.default`.

Registrations made in a container are distinct from registrations made in another container. Registrations _within_ a container can be disambiguated using a name, e.g.,

```swift
_ = Guise.register(factory: Plink(), name: Name.plink, container: Container.plinks)
_ = Guise.register(instance: Plink(), container: Container.plinks)
```

The two registrations above are disambiguated by name, though they register the same type in the same container. The name of the first registration is `Name.plink` and the second is `Guise.Name.default`.

### Keys

The return type of the `register` overloads is `Key<T>`, where `T` is the registered type. A key uniquely identifies a registration. Any two registrations that would produced the same key are the same registration. A subsequent registration producing the same key as a previous registration overwrites the previous registration, as discussed above in the section on names. A key consists of three facts about a registration: its registered type, name, and container. Other details, such as metadata (see below) and caching do not distinguish registrations.

There are two types of keys: the type-safe `Key<T>` and the type-erased `AnyKey`. In the case of `AnyKey`, the registered type is still "remembered", but it is remembered as a string and not as a generic type parameter.

Direct use of keys is uncommon. There are `register` and `resolve` overloads that take keys. In fact, the other overloads construct a key and then call these "master" overloads. The primary use of keys is with filtering and unregistering, both of which will be discussed below.

### Parameters

Most of the time, you should perform registration with the `factory:` and `instance:` overloads of the `register` method, rather than registering a resolution block directly. However, one case in which you cannot do this is when a parameter must be passed when resolving. The resolution block can take an optional parameter (but only one):

```swift
struct Wibble {
  let thibb: String
  init(thibb: String) {
    self.thibb = thibb
  }
}

_ = Guise.register{ Wibble(thibb: $0) }
```

Swift figures out the type of `$0` through type inference. Resolution is straightforward:

```swift
let wibble: Wibble = Guise.resolve(parameter: "flerb")!
```

If more than one parameter is needed, pass a tuple or other structured type.

### Dependency Injection

Very often dependencies have other dependencies. Explicitly using Guise within a type is not recommended. For instance, don't do this:

```swift
struct Sblib {
  init() {

  }
}

_ = Guise.register(factory: Sblib())

struct Throckmorton {
  let sblib: Sblib
  init() {
    sblib = Guise.resolve()!
  }
}

_ = Guise.register(factory: Throckmorton())
```

Instead, do this:

```swift
struct Throckmorton {
  let sblib: Sblib
  init(sblib: Sblib) {
    self.sblib = sblib
  }
}

_ = Guise.register(factory: Throckmorton(sblib: Guise.resolve()!))
```

Of course, there are situations in which this is not possible. In Cocoa and Cocoa Touch, one usually does not have control over the creation of controllers. The framework does this for you. So the direct use of Guise in controllers is unavoidable.

