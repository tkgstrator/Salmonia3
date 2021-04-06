//
//  ProductManager.swift
//  Salmonia3
//
//  Created by Devonly on 3/14/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductManger {

    public class func getFutureRotation(competion: @escaping (JSON?, Error?) -> Void ) {
        let url = "https://salmonia2-api.netlify.app/coop.json"

        AF.request(url, method: .get)
            .validate(statusCode: 200...200)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    competion(JSON(value), nil)
                case .failure(let error):
                    competion(nil, error)
                }
            }
    }
}
