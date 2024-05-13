//
//  AnyEncoder.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

public protocol AnyEncoder {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: AnyEncoder { }
