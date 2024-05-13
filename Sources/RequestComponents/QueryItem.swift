//
//  File.swift
//  
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

public struct QueryItem: RequestComponent {
    private let name: String
    private let value: Encodable
    
    init(_ name: String, value: Encodable) {
        self.name = name
        self.value = value
    }
    
    func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.with(queryItem: name, equaling: value)
    }
}

public struct QueryItems: RequestComponent {
    private let queryItems: [String: Encodable]

    public init( queryItems: [String : Encodable]) {
        self.queryItems = queryItems
    }
    
    func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.with(queryItems: queryItems)
    }
}
