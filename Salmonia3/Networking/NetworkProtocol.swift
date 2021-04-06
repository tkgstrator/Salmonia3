//
//  NetworkProtocol.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import Foundation
import Alamofire

protocol APIProtocol {
    associatedtype ResponseType: Decodable

    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get set }
    var headers: [String: String]? { get }
    var allowConstrainedNetworkAccess: Bool { get }
}

extension APIProtocol {
    var baseURL: URL {
        return URL(string: "https://salmon-stats-api.yuki.games/api/")!
    }

    var headers: [String: String]? {
        return nil
    }

    var allowConstrainedNetworkAccess: Bool {
        return true
    }
}

protocol RequestProtocol: APIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get set }
    var encoding: JSONEncoding { get }
}

extension RequestProtocol {
    var encoding: JSONEncoding {
        return JSONEncoding.default
    }

    public func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = TimeInterval(5)
        request.allowsConstrainedNetworkAccess = allowConstrainedNetworkAccess

        if let params = parameters {
            request = try encoding.encode(request, with: params)
        }

        return request
    }
}
