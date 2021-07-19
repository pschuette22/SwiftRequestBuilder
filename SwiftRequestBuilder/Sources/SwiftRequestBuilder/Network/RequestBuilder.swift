//
//  RequestBuilder.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
}

class RequestBuilder<T: RequestBody> {
    var encoder: AnyEncoder = JSONEncoder()
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    var timeoutInterval: TimeInterval = 60 // 60 second timeout by default

    // Request Components
    private(set) var httpMethod: HTTPMethod = .get
    private(set) var scheme: String = ""
    private(set) var host: String = ""
    private(set) var pathComponents = [String]()
    private(set) var headers = [String: String]()
    private(set) var queryItems = [String: String]()
    private(set) var httpBody: T?
    private(set) var documentURL: URL?
    
    /// Combine components into a URL at runtime
    private var url: URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        var path = pathComponents.joined(separator: "/")
        // Just adds in a little safety in case you want to use `/` for readability
        path = path.replacingOccurrences(of: "//", with: "/")
        urlComponents.path = path
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        // swiftlint:disable:next force_unwrapping
        return urlComponents.url!
    }
}

// MARK: - Build
extension RequestBuilder {
    func build() -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval
        )

        request.httpMethod = httpMethod.rawValue

        if !headers.isEmpty {
            request.allHTTPHeaderFields = headers
        }
        if let httpBody = self.httpBody {
            // swiftlint:disable:next force_try
            request.httpBody = try! encoder.encode(httpBody)
        }

        request.mainDocumentURL = documentURL

        return request
    }
}

// MARK: - Setters
extension RequestBuilder {
    @discardableResult
    func encoder(_ encoder: AnyEncoder) -> RequestBuilder {
        self.encoder = encoder
        return self
    }
    
    @discardableResult
    func cachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> RequestBuilder {
        self.cachePolicy = cachePolicy
        return self
    }
    
    @discardableResult
    func with(httpMethod: HTTPMethod) -> RequestBuilder {
        self.httpMethod = httpMethod
        return self
    }

    @discardableResult
    func with(baseURL: URL) -> RequestBuilder {
        // Found ourselves a bug
        // https://bugs.swift.org/browse/SR-11593
        self.scheme = baseURL.scheme ?? ""
        self.host = baseURL.host ?? ""
        assert(pathComponents.isEmpty, "Base URL should be set before path components")
        self.pathComponents = baseURL.path.components(separatedBy: "/")

        return self
    }
    
    @discardableResult
    func with(headers: [String: String]) -> RequestBuilder {
        self.headers.merge(headers) { $1 }
        return self
    }
    
    @discardableResult
    func with(header: String, equaling value: String) -> RequestBuilder {
        self.headers[header] = value
        return self
    }
    
    @discardableResult
    func with(pathComponents: [String]) -> RequestBuilder {
        self.pathComponents.append(contentsOf: pathComponents)
        return self
    }
    
    @discardableResult
    func with(pathComponent: String) -> RequestBuilder {
        self.pathComponents.append(pathComponent)
        return self
    }
    
    @discardableResult
    func with(queryItems: [String: Encodable]) -> RequestBuilder {
        queryItems.forEach { name, value in
            self.with(queryItem: name, equaling: value)
        }
        return self
    }

    @discardableResult
    func with(queryItem name: String, equaling value: Encodable) -> RequestBuilder {
        switch value {
        case let bool as Bool:
            queryItems[name] = bool.stringValue

        case let number as NSNumber:
            queryItems[name] = number.stringValue

        case let string as String:
            queryItems[name] = string

        default:
            assertionFailure("Unrecognized query item type: \(value)")
        }
        return self
    }
    
    @discardableResult
    func with(httpBody: T) -> RequestBuilder {
        self.httpBody = httpBody // AnyEncodable(value: httpBody)
        return self
    }
    
    @discardableResult
    func with(documentURL: URL) -> RequestBuilder {
        self.documentURL = documentURL
        return self
    }
}

// MARK: - Bool+StringValue
private extension Bool {
    var stringValue: String {
        return self ? "1" : "0"
    }
}
