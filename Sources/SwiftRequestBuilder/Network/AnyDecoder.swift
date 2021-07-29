//
//  AnyDecoder.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

public protocol AnyDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: AnyDecoder { }
