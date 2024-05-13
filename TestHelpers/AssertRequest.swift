//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation
import XCTest
@testable import SwiftRequestBuilder
    
extension XCTestCase {
    public static func assertRequest<T: RequestBody>(
        _ urlRequest: URLRequest,
        matches blueprint: Blueprint<T>,
        file: StaticString = #file,
        line: UInt = #line
        ) throws {

        let method = try XCTUnwrap(httpMethod, "Undefined http method", file: file, line: line)
        XCTAssertEqual(method, blueprint.method.rawValue, file: file, line: line)
        
        let unwrappedURL = try XCTUnwrap(url, "Undefined url", file: file, line: line)
        let blueprintURL = try XCTUnwrap(
            URL(string: blueprint.url),
            "Missing blueprint URL", 
            file: file,
            line: line
        )
        
        XCTAssertEqual(
            unwrappedURL.scheme, 
            blueprintURL.scheme, 
            "Mismatched schema: \(unwrappedURL.schema), expected \(blueprintURL.schema)", 
            file: file,
            line: line
        )

        XCTAssertEqual(unwrappedURL.host, blueprintURL.host, file: file, line: line)

        XCTAssertEqual(unwrappedURL.pathComponents, blueprintURL.pathComponents, file: file, line: line)
        if let queryList = blueprintURL.query?.components(separatedBy: "&") {
            let unwrappdeQuery = try XCTUnwrap(unwrappedURL.query, file: file, line: line)
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
