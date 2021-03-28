//
//  NetworkPublisher.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import Foundation
import Combine
import Alamofire
import SwiftyJSON

struct NetworkPublisher {
    
    private static let contentType = ["application/json"]
    private static let retryCoutn = 1
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func publish<T: RequestProtocol, V: Decodable>(_ request: T) -> Future<V, APIError> where T.ResponseType == V {
        return Future { promise in
            let alamofire = AF.request(request)
                .validate(statusCode: 200...300)
                .validate(contentType: contentType)
                .cURLDescription { request in
                    print(request)
                }
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        do {
                            // RequestTypeによってデコーダを切り替える
                            let json = try JSON(value).rawData()
                            print("RESPONSE", JSON(value))
                            let data = try decoder.decode(V.self, from: json)
                            print("ENCODED RESPONSE", dump(data))
                            promise(.success(data))
                        } catch(let error) {
                            print(error)
                            promise(.failure(APIError.invalid))
                        }
                    case .failure(let error):
                        print(error)
                        promise(.failure(APIError.failure))
                    }
                }
            alamofire.resume()
        }
    }
}

public enum APIError: Error {
    case failure
    case invalid
    case requests
    case unavailable
    case upgrade
    case unknown
    case badrequests
}
