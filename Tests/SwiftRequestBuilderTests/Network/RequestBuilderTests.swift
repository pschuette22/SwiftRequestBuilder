//
//  RequestBuilderTests.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation
import XCTest
@testable import SwiftRequestBuilder

final class RequestBuilderTests: XCTestCase { }

// MARK: - Simple Request Body
extension RequestBuilderTests {
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
extension RequestBuilderTests {
    func test_simpleGetRequest() throws {
        let blueprint = URLRequest.Blueprint(
            bodyType: EmptyBody.self,
            method: .get,
            url: "https://google.com",
            headers: ["header1": "value"]
        )
        
        let request = RequestBuilder()
            .with(httpMethod: HTTPMethod.get)
            .with(baseURL: URL(string: "https://google.com")!)
            .with(header: "header1", equaling: "value")
            .with(httpBody: EmptyBody())
            .build()
        
        try request.assertEqual(to: blueprint)
    }
}

// MARK: - Post Request Tests
extension RequestBuilderTests {
    func test_simplePostRequest() throws {
        let blueprint = URLRequest.Blueprint(
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
        
        let request = RequestBuilder()
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
        
        try request.assertEqual(to: blueprint)
    }
}
