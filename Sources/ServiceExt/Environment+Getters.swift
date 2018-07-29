import Foundation
import Service

#if os(Linux)
import Glibc
#else
import Darwin
#endif

public extension Environment {
    /// Gets a key from the process environment
    public static func get(_ key: String) -> Int? {
        if let value: String = self.get(key), let parsed = Int(value) {
            return parsed
        }

        return nil
    }

    /// Gets a key from the process environment
    public static func get(_ key: String) -> Bool? {
        if let value: String = self.get(key), let parsed = value.lowercased().bool {
            return parsed
        }

        return nil
    }

    /// Gets a key from the process environment
    public static func get(_ key: String, _ fallback: String) -> String {
        return self.get(key) ?? fallback
    }

    ///
    /// Return the integer value for `name` in the environment, returning default if not present
    ///
    public static func get(_ key: String, _ fallback: Int) -> Int {
        guard let value: Int = self.get(key) else {
            return fallback
        }

        return value
    }

    ///
    /// Return the integer value for `name` in the environment, returning default if not present
    ///
    public static func get(_ key: String, _ fallback: Bool) -> Bool {
        guard let value: Bool = self.get(key) else {
            return fallback
        }

        return value
    }
}
