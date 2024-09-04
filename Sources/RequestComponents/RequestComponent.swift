//
//  RequestComponent.swift
//
//
//  Created by Peter Schuette on 5/12/24.
//

import Foundation

public protocol RequestComponent {
    func apply<T: RequestBody>(to factory: RequestFactory<T>) -> RequestFactory<T>
}
