//
//  File.swift
//  
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

public struct CachePolicy: RequestComponent {
    private let cachePolicy: URLRequest.CachePolicy
    
    public init(_ cachePolicy: URLRequest.CachePolicy) {
        self.cachePolicy = cachePolicy
    }
    
    public func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.cachePolicy(cachePolicy)
    }
}
