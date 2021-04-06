//
//  SalmonStatsAPI.swift
//  Salmonia3
//
//  Created by Devonly on 3/28/21.
//

import Foundation
import Combine
import SwiftUI

class SalmonStatsAPI {

    @AppStorage("apiToken") var apiToken: String?

    init() {

    }

    func uploadResultToSalmonStats(from results: [[String: Any]]) -> Future<SalmonStats.UploadResult, APIError> {
        let request = UploadResultRequest(from: results, token: apiToken!)
        return NetworkPublisher.publish(request)
    }

    private func remote<Request: RequestProtocol>(request: Request) -> Future<Request.ResponseType, APIError> {
        return NetworkPublisher.publish(request)
    }

}
