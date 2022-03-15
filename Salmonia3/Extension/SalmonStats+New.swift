//
//  SalmonStats+New.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/14.
//

import Foundation
import SalmonStats
import SplatNet2
import Common
import Alamofire
import Combine


    
extension SalmonStats {
    func uploadWaveResults(_ results: [CoopResult.WaveDetail]) -> AnyPublisher<UploadWaveResult.Response, SP2Error> {
        let request = UploadWaveResult()
        return publish(request)
    }
    
    func uploadWaveResults
}
