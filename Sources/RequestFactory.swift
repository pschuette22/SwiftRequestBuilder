//
//  RequestBuilder.swift
//  
//
//  Created by Peter Schuette on 7/18/21.
//

import Foundation

public class RequestFactory<T: RequestBody> {
    var encoder: AnyEncoder
    var cachePolicy: URLRequest.CachePolicy
    var timeoutInterval: TimeInterval
    
    // Request Components
    private(set) var httpMethod: HTTPMethod = .get
    private(set) var scheme: String = ""
    private(set) var host: String = ""
    private(set) var pathComponents = [String]()
    private(set) var headers = [String: String]()
    private(set) var queryItems = [String: String]()
    private(set) var httpBody: T?
    private(set) var documentURL: Foundation.URL?
    
    public required init(
        encoder: AnyEncoder = JSONEncoder(),
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = Constants.defaultTimeoutInterval
    ) {
        self.encoder = encoder
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }
    
    /// Combine components into a URL at runtime
    public var url: Foundation.URL {
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

    // MARK: - Build
    /// Build the request
    public func build() -> URLRequest {
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
public extension RequestFactory {
    @discardableResult
    func encoder(_ encoder: AnyEncoder) -> RequestFactory {
        self.encoder = encoder
        return self
    }
    
    @discardableResult
    func cachePolicy(_ cachePolicy: URLRequest.CachePolicy) -> RequestFactory {
        self.cachePolicy = cachePolicy
        return self
    }
    
    @discardableResult
    func with(httpMethod: HTTPMethod) -> RequestFactory {
        self.httpMethod = httpMethod
        return self
    }

    @discardableResult
    func with(baseURL: Foundation.URL) -> RequestFactory {
        // Found ourselves a bug
        // https://bugs.swift.org/browse/SR-11593
        self.scheme = baseURL.scheme ?? ""
        self.host = baseURL.host ?? ""
        assert(pathComponents.isEmpty, "Base URL should be set before path components")
        self.pathComponents = baseURL.path.components(separatedBy: "/")

        return self
    }
    
    @discardableResult
    func with(headers: [String: String]) -> RequestFactory {
        self.headers.merge(headers) { $1 }
        return self
    }
    
    @discardableResult
    func with(header: String, equaling value: String) -> RequestFactory {
        self.headers[header] = value
        return self
    }
    
    @discardableResult
    func with(pathComponents: [String]) -> RequestFactory {
        self.pathComponents.append(contentsOf: pathComponents)
        return self
    }
    
    @discardableResult
    func with(pathComponent: String) -> RequestFactory {
        self.pathComponents.append(pathComponent)
        return self
    }
    
    @discardableResult
    func with(queryItems: [String: Encodable]) -> RequestFactory {
        queryItems.forEach { name, value in
            self.with(queryItem: name, equaling: value)
        }
        return self
    }

    @discardableResult
    func with(queryItem name: String, equaling value: Encodable) -> RequestFactory {
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
    func with(httpBody: T) -> RequestFactory {
        self.httpBody = httpBody
        return self
    }
    
    @discardableResult
    func with(documentURL: Foundation.URL) -> RequestFactory {
        self.documentURL = documentURL
        return self
    }
}

// MARK: - Bool+StringValue

extension Bool {
    var stringValue: String {
        return self ? "1" : "0"
    }
}

// MARK: - Constants

public enum Constants {
    public static let defaultTimeoutInterval: TimeInterval = 60
}
