//
//  Future+Optional.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 10/31/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async
import Core

public extension Future where Expectation: OptionalType {
    public func `nil`(or error: @autoclosure @escaping () -> Error) -> Future<Expectation.WrappedType?> {
        return map { optional in
            if let _ = optional.wrapped {
                throw error()
            }

            return optional.wrapped
        }
    }

    public func `nil`() -> Future<Bool> {
        return map { optional in
            optional.wrapped == nil
        }
    }
}
