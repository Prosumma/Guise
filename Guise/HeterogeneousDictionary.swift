//
//  File.swift
//  
//
//  Created by Gregory Higley on 3/28/20.
//

import Foundation

/**
 A dictionary whose values may be of any type. Entries
 are set and retrieved with a generic subscript.
 
 When subscripting, an element is returned if…
 
 1. Its key exists in the collection.
 2. Its value is of the requested type.
 
 This means that subscripting is not a reliable way
 to check for the existence of an entry. To confirm
 the existence of an entry regardless of type, check
 that the key exists, e.g.,
 
 ```swift
 let het: HeterogeneousDictionary<String> = ["x": 7]
 let x: String? = het["x"] // Returns nil, because 7 is not a string
 if het.keys.contains("x") {
   // "x" is present
 }
 ```
 
 To get the underlying type of an entry, use Swift's `type(of:)`,
 e.g.,
 
 ```swift
 if let x: Any = het["x"] {
   print(type(of: x))
 }
 ```
 */
struct HeterogeneousDictionary<Key: Hashable>: Collection {
  typealias Storage = Dictionary<Key, Any>
  
  typealias Element = Storage.Element
  typealias Index = Storage.Index
  
  fileprivate var dictionary: Storage = [:]
  
  var startIndex: Index {
    dictionary.startIndex
  }
  
  var endIndex: Index {
    dictionary.endIndex
  }
  
  func index(after i: Index) -> Index {
    dictionary.index(after: i)
  }
    
  subscript(position: Index) -> Element {
    dictionary[position]
  }
  
  var keys: Storage.Keys {
    return dictionary.keys
  }
  
  var values: Storage.Values {
    return dictionary.values
  }
    
  subscript<Value>(key: Key) -> Value? {
    get { dictionary[key] as? Value }
    set { dictionary[key] = newValue }
  }
}

extension HeterogeneousDictionary: ExpressibleByDictionaryLiteral {
  init(dictionaryLiteral elements: (Key, Any)...) {
    dictionary = Dictionary(uniqueKeysWithValues: elements)
  }
}
