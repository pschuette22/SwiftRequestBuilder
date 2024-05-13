//
//  RequestBuilder.swift
//
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

@resultBuilder
struct RequestBuilder<T: RequestBody> {
    static func buildBlock(_ components: RequestComponent...) -> URLRequest {
        components.reduce(RequestFactory<T>()) {
            $1.apply(to: $0)
        }
        .build()
    }
}

extension URLRequest {
    public init<T: RequestBody>(
        _ body: T.Type = EmptyBody.self,
        @RequestBuilder<T> builder: () -> URLRequest
    ) {
        self = builder()
    }
}
