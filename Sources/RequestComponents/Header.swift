//
//  Header.swift
//
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

public struct Header: RequestComponent {
    private let header: String
    private let value: String
    
    public init(_ header: String, value: String) {
        self.header = header
        self.value = value
    }
    
    public func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.with(header: header, equaling: value)
    }
}

public struct Headers: RequestComponent {
    private let headers: [String: String]
    
    public init(_ headers: [String : String]) {
        self.headers = headers
    }
    
    public func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.with(headers: headers)
    }
}
