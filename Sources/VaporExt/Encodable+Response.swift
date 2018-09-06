//
//  Encodable+Response.swift
//  VaporExt
//
//  Created by Gustavo Perdomo on 09/06/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

public extension Future where T: Encodable {
    /// Transforms a Future<Encodable> to a Future<Response> using the passed configuration
    ///
    /// - Parameters:
    ///   - req: the request
    ///   - status: the status of the new response
    ///   - contentType: The MediaType to encode the data
    /// - Returns: A Future<Response> with the encodable data
    /// - Throws: Errors errors during encoding
    public func toResponse(on req: Request, as status: HTTPStatus, contentType: MediaType = .json) throws -> Future<Response> {
        return map(to: Response.self) { tenant in
            let response = req.makeResponse()
            try response.content.encode(tenant, as: contentType)
            response.http.status = status

            return response
        }
    }
}
