//
//  HTTPMethod.swift
//  
//
//  Created by Peter Schuette on 7/20/21.
//

import Foundation

public enum HTTPMethod: String, RequestComponent {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    
    public init(_ method: HTTPMethod) {
        // Gives builder syntax HTTPMethod(.get)
        self = method
    }
    
    public func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.with(httpMethod: self)
    }
}
