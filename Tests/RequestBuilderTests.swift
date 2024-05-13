//
//  RequestBuilderTests.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation
import XCTest
@testable import SwiftRequestBuilder
import SwiftRequestBuilderTestHelpers

final class RequestFactoryTests: XCTestCase { }

// MARK: - Simple Request Body
extension RequestFactoryTests {
    struct SimpleTestBody: RequestBody {
        var hello: String
        var world: Int
        var isExcited: Bool
        
        init(
            hello: String,
            world: Int,
            isExcited: Bool) {
            self.hello = hello
            self.world = world
            self.isExcited = isExcited
        }
    }
}

// MARK: - Get Request Tests
extension RequestFactoryTests {
    func test_simpleGetRequest() throws {
        let blueprint = Blueprint<EmptyBody>(
            method: .get,
            url: "https://google.com",
            headers: ["header1": "value"]
        )
        
        let request = RequestFactory<EmptyBody>()
            .with(httpMethod: HTTPMethod.get)
            .with(baseURL: URL(string: "https://google.com")!)
            .with(header: "header1", equaling: "value")
            .with(httpBody: EmptyBody())
            .build()
        
        try assertRequest(request, matches: blueprint)
    }
}

// MARK: - Post Request Tests
extension RequestFactoryTests {
    func test_simplePostRequest() throws {
        let blueprint = Blueprint(
            bodyType: SimpleTestBody.self,
            method: HTTPMethod.post,
            url: "https://google.com",
            headers: ["header1": "value"],
            body: SimpleTestBody(
                hello: "Hello!",
                world: 1,
                isExcited: true
            ),
            documentURL: nil
        )
        
        let request = RequestFactory()
            .with(httpMethod: .post)
            .with(baseURL: URL(string: "https://google.com")!)
            .with(header: "header1", equaling: "value")
            .with(
                httpBody: SimpleTestBody(
                    hello: "Hello!",
                    world: 1,
                    isExcited: true
                )
            )
            .build()
        
        try assertRequest(request, matches: blueprint)
    }
}
