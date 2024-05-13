import Foundation
import SwiftRequestBuilder

public struct Blueprint<T: RequestBody> {
    public var decoder: AnyDecoder = JSONDecoder()
    public var bodyType: T.Type
    public var method: HTTPMethod
    public var url: String
    public var headers: [String: String]
    public var body: T?
    public var documentURL: URL?
    
    public init(
        decoder: AnyDecoder = JSONDecoder(),
        bodyType: T.Type = EmptyBody.self,
        method: HTTPMethod = .get,
        url: String,
        headers: [String : String],
        body: T? = nil,
        documentURL: URL? = nil
    ) {
        self.decoder = decoder
        self.method = method
        self.bodyType = bodyType
        self.url = url
        self.headers = headers
        self.body = body
        self.documentURL = documentURL
    }
}
