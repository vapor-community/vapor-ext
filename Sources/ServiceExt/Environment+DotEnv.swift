//
//  Environment+DotEnv.swift
//  ServiceExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Foundation
import Service

#if os(Linux)
import Glibc
#else
import Darwin
#endif

public extension Environment {
    public static func dotenv(filename: String = ".env") {
        guard let path = getAbsolutePath(relativePath: "/\(filename)"),
              let contents = try? String(contentsOfFile: path, encoding: .utf8) else {
            return
        }

        contents.enumerateLines { (line, _) -> Void in
            // ignore comments
            if line.starts(with: "#") {
                return
            }

            // ignore lines that appear empty
            if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return
            }

            // extract key and value which are separated by an equals sign
            let parts = line.components(separatedBy: "=")

            let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            var value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)

            // remove surrounding quotes from value & convert remove escape character before any embedded quotes
            if value[value.startIndex] == "\"" && value[value.index(before: value.endIndex)] == "\"" {
                value.remove(at: value.startIndex)
                value.remove(at: value.index(before: value.endIndex))
                value = value.replacingOccurrences(of: "\\\"", with: "\"")
            }
            setenv(key, value, 1)
        }
    }

    ///
    /// Determine absolute path of the given argument relative to the current
    /// directory
    ///
    private static func getAbsolutePath(relativePath: String) -> String? {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let filePath = currentPath + relativePath
        if fileManager.fileExists(atPath: filePath) {
            return filePath
        } else {
            return nil
        }
    }
}
