import Foundation
import SwiftRequestBuilder

public struct Blueprint<T: RequestBody> {
    public var decoder: AnyDecoder = JSONDecoder()
    public var bodyType: T.Type?
    public var method: HTTPMethod
    public var url: String
    public var headers: [String: String]
    public var body: T?
    public var documentURL: URL?
}