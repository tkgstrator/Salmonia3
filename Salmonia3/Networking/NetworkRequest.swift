//
//  NetworkRequest.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import Foundation
import Alamofire

public class UploadResultRequest: RequestProtocol {
    var parameters: Parameters?

    var method: HTTPMethod {
        return .post
    }

    var path: String

    var headers: [String: String]?

    typealias ResponseType = SalmonStats.UploadResult

    init(from results: [[String: Any]], token: String) {
        self.path = "results"
        self.headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        self.parameters = ["results": results]
    }
}
