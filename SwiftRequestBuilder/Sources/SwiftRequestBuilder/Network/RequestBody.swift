//
//  RequestBody.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

protocol RequestBody: Codable, Equatable { }

struct EmptyBody: RequestBody { }
