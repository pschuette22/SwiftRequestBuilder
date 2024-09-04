//
//  Body.swift
//
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

public struct Body<B: RequestBody>: RequestComponent {
    private let body: B
    
    public init(_ body: B) {
        self.body = body
    }
    
    public func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        guard let unwrapped = body as? T else {
            assertionFailure("Incorrect body type")
            return factory
        }

        return factory.with(httpBody: unwrapped)
    }
}
