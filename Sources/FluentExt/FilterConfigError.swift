//
//  FilterValue.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Debugging

/// Errors that can be thrown while working with Filterable.
public struct FilterableError: Debuggable {
    public var identifier: String

    public var reason: String
}
