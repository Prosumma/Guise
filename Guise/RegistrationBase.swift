//
//  RegistrationBase.swift
//  Guise
//
//  Created by Gregory Higley on 2/26/20.
//  Copyright © 2020 Gregory Higley. All rights reserved.
//

import Foundation

public class RegistrationBase: Registration {
  public let metadata: Any

  public init(metadata: Any) {
    self.metadata = metadata
  }

  public func resolve<Type, Arg>(type: Type.Type, resolver: Resolver, arg: Arg) -> Type? {
    NSException(name: .internalInconsistencyException, reason: "Method not implemented", userInfo: nil).raise()
    return nil
  }

  public func inject(resolver: Resolver, into target: AnyObject, args: [Key: Any]) {
    NSException(name: .internalInconsistencyException, reason: "Method not implemented", userInfo: nil).raise()
  }

}
