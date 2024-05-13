//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation
import XCTest
@testable import SwiftRequestBuilder
    
extension XCTestCase {
    public func assertRequest<T: RequestBody>(
        _ urlRequest: URLRequest,
        matches blueprint: Blueprint<T>,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        XCTAssertEqual(
            urlRequest.httpMethod,
            blueprint.method.rawValue,
            "Mismatching request method",
            file: file,
            line: line
        )
        
        let unwrappedURL = try XCTUnwrap(urlRequest.url, "Undefined url", file: file, line: line)
        let blueprintURL = try XCTUnwrap(
            URL(string: blueprint.url),
            "Missing blueprint URL", 
            file: file,
            line: line
        )
        
        XCTAssertEqual(
            unwrappedURL.scheme, 
            blueprintURL.scheme, 
            "Mismatched scheme: \(unwrappedURL.scheme ?? "<nil>"), expected \(blueprintURL.scheme ?? "<nil>")",
            file: file,
            line: line
        )

        XCTAssertEqual(
            unwrappedURL.host, 
            blueprintURL.host,
            "Mismatched host",
            file: file,
            line: line
        )

        XCTAssertEqual(
            unwrappedURL.pathComponents,
            blueprintURL.pathComponents,
            "Mimatched url components",
            file: file,
            line: line
        )

        if let queryList = blueprintURL.query?.components(separatedBy: "&") {
            let unwrappedQuery = try XCTUnwrap(unwrappedURL.query, file: file, line: line)
            queryList.forEach {
                // Assert every query item is contained in the blueprint string
                // Needs to be done this way because we can't guarantee order
                XCTAssert(unwrappedQuery.contains($0), "Missing query \($0)", file: file, line: line)
            }
        } else {
            XCTAssertNil(unwrappedURL.query, file: file, line: line)
        }
        
        try urlRequest.allHTTPHeaderFields?.forEach { key, value in
            let expected = try XCTUnwrap(
                blueprint.headers[key], 
                "Missing header value for '\(key)' in blueprint", 
                file: file, 
                line: line
            )
            XCTAssertEqual(
                value,
                expected,
                "Expected header value '\(expected)' for key '\(key)' but found '\(value)'", 
                file: file, 
                line: line
            )
        }
        
        if
            let httpBody = urlRequest.httpBody,
            blueprint.bodyType != EmptyBody.self
        {
            let decodedBody = try blueprint.decoder.decode(
                blueprint.bodyType.self,
                from: httpBody
            )
            XCTAssertEqual(
                decodedBody, 
                blueprint.body,
                "Request body does not match blueprint body",
                file: file,
                line: line
            )
        } else {
            XCTAssertNil(
                blueprint.body,
                "Request body type does not match blueprint body type",
                file: file,
                line: line
            )
        }
        
        XCTAssertEqual(
            urlRequest.mainDocumentURL,
            blueprint.documentURL,
            "Mismatched document url",
            file: file,
            line: line
        )
    }
}
