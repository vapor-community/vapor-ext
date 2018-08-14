//
//  FilterConfig.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 08/14/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Foundation

struct FilterConfig {
    var method: QueryFilterMethod
    var value: String
}

internal let QueryParamRegex = "(\(QueryFilterMethod.allCases.map { $0.rawValue }.joined(separator: "|")))?:?(.*)"

internal extension String {
    var toFilterConfig: FilterConfig {
        let result = self.capturedGroups(withRegex: QueryParamRegex)

        var method = QueryFilterMethod.equal

        if let rawValue = result[0], let _method = QueryFilterMethod.init(rawValue: rawValue) {
            method = _method
        }

        return FilterConfig(method: method, value: result[1] ?? "")
    }

    func capturedGroups(withRegex pattern: String) -> [String?] {

        var results = [String?]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))

        guard let match = matches.first else { return results }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)

            let matchedString = capturedGroupIndex.location == NSNotFound ? nil : (self as NSString).substring(with: capturedGroupIndex)

            results.append(matchedString)
        }

        return results
    }
}
