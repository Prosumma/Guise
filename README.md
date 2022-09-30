# Guise 10

Guise is an elegant, flexible, type-safe dependency resolution framework for Swift.

- [x] Flexible dependency resolution, with optional caching
- [x] Elegant, straightforward registration
- [x] Thread-safe
- [x] Supports `throw`ing and `async` initializers
- [x] Simplifies unit testing
- [x] Pass arbitrary state when resolving
- [x] Lazy resolution
- [x] Swift 5.7+
- [x] Support for iOS 8.0+, macOS 10.9+, watchOS 2+, tvOS 9+

> **Guise**, _n._ An external form, appearance, or manner of presentation, typically concealing the true nature of something.

### What Makes Guise Better Than Those Other Guys?

- Guise doesn't require any modification to the types you register. There are no special interfaces like `Injectable` or `Component` to implement. There are no special initializers or properties to add. Any type can be registered as is.
- Guise was designed with Swift in mind. Other DI frameworks for Swift appear to be translations of frameworks from other languages, particularly C&#x266f; and Java. These languages have strengths and weaknesses that are different from those of Swift, and those strengths and weaknesses are reflected in the design of these frameworks. This makes them clumsy in Swift.
- Many of these frameworks register _types_ directly. Guise registers _blocks_ directly and _types_ indirectly. This simple distinction removes an enormous amount of complexity while introducing greater compile-time safety. When combined with Swift's `@autoclosure` attribute, it makes registration elegant and minimal. (See the sections on factory and instance registration below.)
- Guise was designed to be simple rather than easy. Turns out it's both.

### Changes

Guise 10 is not backwards compatible with 9.

- [x] Guise 10.0.0 removes support for CocoaPods and Carthage. This is now a pure Swift package. 
- [x] Metadata, containers and names have been merged into `tags`. (See below.)
- [x] Injection has been removed but will make a comeback in a point release. (If you need it, use version 9 for now.)
- [x] The global `Guise` type has been removed. If you want a global container, you'll have to do it yourself.

### Examples

