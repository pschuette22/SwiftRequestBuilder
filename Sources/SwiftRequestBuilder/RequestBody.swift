//
//  RequestBody.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

public protocol RequestBody: Codable, Equatable { }

public struct EmptyBody: RequestBody { }
