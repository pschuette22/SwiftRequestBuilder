//
//  Response.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

public protocol Response: Codable, Equatable { }

public struct EmptyResponse: Response { }
