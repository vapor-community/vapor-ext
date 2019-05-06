//
//  Environment+Getters.swift
//  ServiceExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Service

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

// MARK: - Methods

public extension Environment {
    /// Gets a key from the process environment.
    ///
    /// - Parameter key: the environment variable name.
    /// - Returns: the environment variable value if exists.
    static func get(_ key: String) -> Int? {
        if let value: String = self.get(key), let parsed = Int(value) {
            return parsed
        }

        return nil
    }

    /// Gets a key from the process environment.
    ///
    /// - Parameter key: the environment variable name.
    /// - Returns: the environment variable value if exists.
    static func get(_ key: String) -> Bool? {
        if let value: String = self.get(key), let parsed = value.lowercased().bool {
            return parsed
        }

        return nil
    }

    /// Gets a key from the process environment.
    ///
    /// - Parameters:
    ///   - key: the environment variable name.
    ///   - fallback: the default value.
    /// - Returns: the environment variable value if exists, otherwise the `fallback` value.
    static func get(_ key: String, _ fallback: String) -> String {
        return get(key) ?? fallback
    }

    /// Gets a key from the process environment.
    ///
    /// - Parameters:
    ///   - key: the environment variable name.
    ///   - fallback: the default value.
    /// - Returns: the environment variable value if exists, otherwise the `fallback` value.
    static func get(_ key: String, _ fallback: Int) -> Int {
        guard let value: Int = self.get(key) else {
            return fallback
        }

        return value
    }

    /// Gets a key from the process environment.
    ///
    /// - Parameters:
    ///   - key: the environment variable name.
    ///   - fallback: the default value.
    /// - Returns: the environment variable value if exists, otherwise the `fallback` value.
    static func get(_ key: String, _ fallback: Bool) -> Bool {
        guard let value: Bool = self.get(key) else {
            return fallback
        }

        return value
    }
}
