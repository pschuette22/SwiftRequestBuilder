//
//  File.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation
import XCTest
@testable import SwiftRequestBuilder

extension URLRequest {
    struct Blueprint<T: RequestBody> {
        var decoder: AnyDecoder = JSONDecoder()
        var bodyType: T.Type?
        var method: HTTPMethod
        var url: String
        var headers: [String: String]
        var body: T?
        var documentURL: URL?
    }
    
    func assertEqual<T: RequestBody>(to blueprint: Blueprint<T>) throws {
        let method = try XCTUnwrap(httpMethod, "Undefined http method")
        XCTAssertEqual(method, blueprint.method.rawValue)
        
        let unwrappedURL = try XCTUnwrap(url, "Undefined url")
        let blueprintURL = try XCTUnwrap(URL(string: blueprint.url))
        
        XCTAssertEqual(unwrappedURL.scheme, blueprintURL.scheme)
        XCTAssertEqual(unwrappedURL.host, blueprintURL.host)
        XCTAssertEqual(unwrappedURL.pathComponents, blueprintURL.pathComponents)
        if let queryList = blueprintURL.query?.components(separatedBy: "&") {
            let unwrappdeQuery = try XCTUnwrap(unwrappedURL.query)
            queryList.forEach {
                // Assert every query item is contained in the blueprint string
                // Needs to be done this way because we can't guarantee order
                XCTAssert(unwrappdeQuery.contains($0), "Query string is missing \($0)")
            }
        } else {
            XCTAssertNil(unwrappedURL.query)
        }
                
        XCTAssertEqual(allHTTPHeaderFields?.count ?? 0, blueprint.headers.count)
        
        try allHTTPHeaderFields?.forEach { key, value in
            let expected = try XCTUnwrap(blueprint.headers[key], "Missing header value for '\(key)' in blueprint")
            XCTAssertEqual(value, expected, "Expected header value '\(expected)' for key '\(key)' but found '\(value)'")
        }
        
        if
            let httpBody = self.httpBody,
            let bodyType = blueprint.bodyType,
            bodyType != EmptyBody.self
        {
            let decodedBody = try blueprint.decoder.decode(bodyType.self, from: httpBody)
            XCTAssertEqual(decodedBody, blueprint.body, "Request body does not match blueprint body")
        } else {
            XCTAssertNil(blueprint.body, "Request body type does not match blueprint body type")
        }
        
        XCTAssertEqual(mainDocumentURL, blueprint.documentURL)
    }
}
