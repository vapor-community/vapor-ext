//
//  SingleValueDecoder.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Vapor

// swiftlint:disable force_unwrapping
/// Decodes nested, single values from data at a key path.
internal struct SingleValueDecoder: Decodable {
    let decoder: Decoder
    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }

    func get<D>(at keyPath: [BasicKey]) throws -> D where D: Decodable {
        let unwrapper = self
        var state = try ContainerState.keyed(unwrapper.decoder.container(keyedBy: BasicKey.self))

        var keys = Array(keyPath.reversed())
        if keys.isEmpty {
            return try unwrapper.decoder.singleValueContainer().decode(D.self)
        }

        while let key = keys.popLast() {
            switch keys.count {
            case 0:
                switch state {
                case let .keyed(keyed):
                    return try keyed.decode(D.self, forKey: key)
                case var .unkeyed(unkeyed):
                    return try unkeyed.nestedContainer(keyedBy: BasicKey.self)
                        .decode(D.self, forKey: key)
                }
            case 1...:
                let next = keys.last!
                if let index = next.intValue {
                    switch state {
                    case let .keyed(keyed):
                        var new = try keyed.nestedUnkeyedContainer(forKey: key)
                        state = try .unkeyed(new.skip(to: index))
                    case var .unkeyed(unkeyed):
                        var new = try unkeyed.nestedUnkeyedContainer()
                        state = try .unkeyed(new.skip(to: index))
                    }
                } else {
                    switch state {
                    case let .keyed(keyed):
                        state = try .keyed(keyed.nestedContainer(keyedBy: BasicKey.self, forKey: key))
                    case var .unkeyed(unkeyed):
                        state = try .keyed(unkeyed.nestedContainer(keyedBy: BasicKey.self))
                    }
                }
            default: fatalError("Unexpected negative key count")
            }
        }
        fatalError("`while let key = keys.popLast()` should never fallthrough")
    }
}

private enum ContainerState {
    case keyed(KeyedDecodingContainer<BasicKey>)
    case unkeyed(UnkeyedDecodingContainer)
}

private extension UnkeyedDecodingContainer {
    mutating func skip(to count: Int) throws -> UnkeyedDecodingContainer {
        for _ in 0 ..< count {
            _ = try nestedContainer(keyedBy: BasicKey.self)
        }
        return self
    }
}
