//
//  SImage.swift
//  Salmonia3
//
//  Created by Devonly on 3/19/21.
//

import Foundation
import SwiftUI

struct SRImage: UIViewRepresentable {
    
    let from: ImageType
    let size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let uiimage = UIImage(named: from.imageURL)
        let size = CGSize(width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        uiimage?.draw(in: CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
    
    enum ImageType: Int {
//        case shakeup        = "00963b1057a02a9ca5b3492aecc38f63"
//        case shakeship      = "0012a0d09f26225edde5fe2edc3fc015"
//        case shakehouse     = "dd2e2e1c801d4cf4322736b9aadd91f6"
//        case shakelift      = "49ca412e830695b6aeb26d74f898a7a5"
//        case shakeride      = "97d1cf22ecf5769735fd66477ba58ab8"
        case bombpitcher    = 2
        case stingray       = 7
        case inkjet         = 8
        case splashdown     = 9
    }
}


extension SRImage.ImageType {
    var imageURL: String {
        switch self {
//        case .shakeup:
//            return ""
//        case .shakeship:
//        case .shakehouse:
//        case .shakelift:
//        case .shakeride:
        case .bombpitcher:
            return "88307509fb9d8a990a4bdd41e12a345c"
        case .stingray:
            return "03c6badf9b8995c873acba2f140988fa"
        case .inkjet:
            return "f244ad5b517e9af5f5be0b710a9803d8"
        case .splashdown:
            return "5c4a265d5d1dd51c7e5577f92d358cb4"
        }
    }
}
