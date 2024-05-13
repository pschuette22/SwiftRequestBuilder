//
//  URL.swift
//
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

extension URL: RequestComponent {
    func apply<T>(to factory: RequestFactory<T>) -> RequestFactory<T> where T : RequestBody {
        factory.with(baseURL: self)
    }
}
