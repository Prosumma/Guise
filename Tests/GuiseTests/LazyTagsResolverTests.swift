//
//  LazyTagsResolverTests.swift
//  GuiseTests
//
//  Created by Gregory Higley on 2022-09-24.
//

import XCTest
@testable import Guise

final class LazyTagsResolverTests: XCTestCase {
  override func setUp() {
    super.setUp()
    prepareForGuiseTests()
  }

  func test_sync0() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 0) { _ in
      [] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 0)
   
    // When
    let ints: [Int] = try ltr.resolve()
    
    // Then
    XCTAssertEqual(ints, [])
  }

  func test_sync1() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 1) { _, arg1 in
      [arg1] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 1)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0)
    
    // Then
    XCTAssertEqual(ints, [0])
  }
  
  func test_sync2() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 2) { _, arg1, arg2 in
      [arg1, arg2] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 2)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1)
    
    // Then
    XCTAssertEqual(ints, [0, 1])
  }
  
  func test_sync3() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 3) { _, arg1, arg2, arg3 in
      [arg1, arg2, arg3] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 3)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2])
  }
  
  func test_sync4() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 4) { _, arg1, arg2, arg3, arg4 in
      [arg1, arg2, arg3, arg4] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 4)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2, 3)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3])
  }
  
  func test_sync5() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 5) { _, arg1, arg2, arg3, arg4, arg5 in
      [arg1, arg2, arg3, arg4, arg5] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 5)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4])
  }
  
  func test_sync6() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 6) { _, arg1, arg2, arg3, arg4, arg5, arg6 in
      [arg1, arg2, arg3, arg4, arg5, arg6] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 6)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5])
  }
  
  func test_sync7() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 7) { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7 in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 7)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5, 6])
  }
  
  func test_sync8() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 8) { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 8)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_sync9() throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 9) { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try container.resolve(tags: 9)
   
    // When
    let ints: [Int] = try ltr.resolve(args: 0, 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_resolve_sync_weak() throws {
    // Given
    var container: Container? = Container()
    container!.register(tags: "s") { _, arg in
      Service(i: arg)
    }
    let ltr: LazyTagsResolver<Service> = try container!.resolve(tags: "s")

    // When
    container = nil

    // Then
    do {
      _ = try ltr.resolve(args: 7)
      XCTFail("Expected resolution to fail.")
    } catch let error as ResolutionError {
      let key = Key(Service.self, tags: "s", args: Int.self)
      guard
        error.key == key,
        case .noResolver = error.reason
      else {
        throw error
      }
    }
  }
  
  func test_async0() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 0) { _ async in
      [] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 0)
   
    // When
    let ints: [Int] = try await ltr.resolve()
    
    // Then
    XCTAssertEqual(ints, [])
  }

  func test_async1() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 1) { _, arg1 async in
      [arg1] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 1)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0)
    
    // Then
    XCTAssertEqual(ints, [0])
  }
  
  func test_async2() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 2) { _, arg1, arg2 async in
      [arg1, arg2] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 2)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1)
    
    // Then
    XCTAssertEqual(ints, [0, 1])
  }
  
  func test_async3() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 3) { _, arg1, arg2, arg3 async in
      [arg1, arg2, arg3] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 3)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2])
  }
  
  func test_async4() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 4) { _, arg1, arg2, arg3, arg4 async in
      [arg1, arg2, arg3, arg4] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 4)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2, 3)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3])
  }
  
  func test_async5() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 5) { _, arg1, arg2, arg3, arg4, arg5 async in
      [arg1, arg2, arg3, arg4, arg5] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 5)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2, 3, 4)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4])
  }
  
  func test_async6() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 6) { _, arg1, arg2, arg3, arg4, arg5, arg6 async in
      [arg1, arg2, arg3, arg4, arg5, arg6] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 6)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2, 3, 4, 5)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5])
  }
  
  func test_async7() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 7) { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7 async in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 7)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2, 3, 4, 5, 6)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5, 6])
  }
  
  func test_async8() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 8) { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 async in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 8)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2, 3, 4, 5, 6, 7)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5, 6, 7])
  }
  
  func test_async9() async throws {
    // Given
    let container: any (Resolver & Registrar) = Container()
    container.register(tags: 9) { _, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 async in
      [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9] as [Int]
    }
    let ltr: LazyTagsResolver<[Int]> = try await container.resolve(tags: 9)
   
    // When
    let ints: [Int] = try await ltr.resolve(args: 0, 1, 2, 3, 4, 5, 6, 7, 8)
    
    // Then
    XCTAssertEqual(ints, [0, 1, 2, 3, 4, 5, 6, 7, 8])
  }
  
  func test_resolve_async_weak() async throws {
    // Given
    var container: Container? = Container()
    container!.register(tags: "s") { _, arg async in
      Service(i: arg)
    }
    let ltr: LazyTagsResolver<Service> = try await container!.resolve(tags: "s")

    // When
    container = nil

    // Then
    do {
      _ = try await ltr.resolve(args: 7)
      XCTFail("Expected resolution to fail.")
    } catch let error as ResolutionError {
      let key = Key(Service.self, tags: "s", args: Int.self)
      guard
        error.key == key,
        case .noResolver = error.reason
      else {
        throw error
      }
    }
  }
}

extension LazyTagsResolverTests {
  class Service {
    let i: Int
    init(i: Int) {
      self.i = i
    }
  }
}
