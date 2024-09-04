//
//  File.swift
//  
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

public struct Encoder: RequestComponent {
    private let encoder: AnyEncoder
    public init(_ encoder: AnyEncoder) {
        self.encoder = encoder
    }
    
    public func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.encoder(encoder)
    }
}
