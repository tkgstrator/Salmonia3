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

}

protocol ImageType {
    var rawValue: Int { get }
    var imageURL: String { get }
}

class Special: ImageType {
    var rawValue: Int
    var imageURL: String

    init(rawValue: Int) {
        self.rawValue = rawValue
        switch SpecialType(rawValue: rawValue) {
        case .bombpitcher:
            imageURL = "88307509fb9d8a990a4bdd41e12a345c"
        case .stingray:
            imageURL = "03c6badf9b8995c873acba2f140988fa"
        case .inkjet:
            imageURL = "f244ad5b517e9af5f5be0b710a9803d8"
        case .splashdown:
            imageURL = "5c4a265d5d1dd51c7e5577f92d358cb4"
        default:
            imageURL = ""
        }
    }

    enum SpecialType: Int, CaseIterable {
        case bombpitcher    = 2
        case stingray       = 7
        case inkjet         = 8
        case splashdown     = 9
    }
}

class Salmonid: ImageType {
    var rawValue: Int
    var imageURL: String

    init(rawValue: Int) {
        self.rawValue = rawValue
        switch SalmonidType(rawValue: rawValue) {
        case .goldie:
            imageURL = "e7a2c9cae2301d8c1678a2aa4fadaba5"
        case .steelhead:
            imageURL = "4c86590828a4ca9271e25ccd799ab82f"
        case .flyfish:
            imageURL = "184b61a46145f2b7340eb65808b84a53"
        case .scrapper:
            imageURL = "b56adfe8983da6cfb3362a6975430a17"
        case .steeleel:
            imageURL = "9da9e56c0634bb7c6aa23dcaf96bc80a"
        case .tower:
            imageURL = "2e1473ff7deefbf5f834b71046271c9c"
        case .maw:
            imageURL = "fab43fc3b7a1d9fa6d204efd12589ae3"
        case .griller:
            imageURL = "9564445e3926734f256c44300dc1828d"
        case .drizzler:
            imageURL = "f28f0f0fe1e418c4da14403e44d1d1ea"
        default:
            imageURL = ""
        }
    }

    enum SalmonidType: Int, CaseIterable {
        case goldie     = 0
        case steelhead  = 1
        case flyfish    = 2
        case scrapper   = 3
        case steeleel   = 4
        case tower      = 5
        case maw        = 6
        case griller    = 7
        case drizzler   = 8
    }
}

extension Salmonid {
    var name: String {
        switch SalmonidType(rawValue: self.rawValue) {
        case .goldie:
            return "Goldie"
        case .steelhead:
            return "Steelhead"
        case .flyfish:
            return "Flyfish"
        case .scrapper:
            return "Scrapper"
        case .steeleel:
            return "Steel Eel"
        case .tower:
            return "Tower"
        case .maw:
            return "Maw"
        case .griller:
            return "Griller"
        case .drizzler:
        return "Drizzler"
        default:
            return ""
        }
    }
}
// struct ImageType {
//    let imageURL: String
//
//    enum Special: Int, CaseIterable {
//        case bombpitcher    = 2
//        case stingray       = 7
//        case inkjet         = 8
//        case splashdown     = 9
//    }
//
//    enum Salmonids: Int, CaseIterable {
//        case goldie     = 0
//        case steelhead  = 1
//        case flyfish    = 2
//        case steeleel   = 3
//        case tower      = 4
//        case maw        = 5
//        case griller    = 6
//        case drizzler   = 7
//    }
// }
//
// extension ImageType.Special {
//    var imageURL: String {
//        switch self {
//        case .bombpitcher:
//            return "88307509fb9d8a990a4bdd41e12a345c"
//        case .stingray:
//            return "03c6badf9b8995c873acba2f140988fa"
//        case .inkjet:
//            return "f244ad5b517e9af5f5be0b710a9803d8"
//        case .splashdown:
//            return "5c4a265d5d1dd51c7e5577f92d358cb4"
//        }
//    }
// }
//
// extension ImageType.Salmonids {
//    var imageURL: String {
//        switch  self {
//        case .goldie:
//            return ""
//        case .steelhead:
//            return ""
//        case .flyfish:
//            return ""
//        case .steeleel:
//            return ""
//        case .tower:
//            return ""
//        case .maw:
//            return ""
//        case .griller:
//            return ""
//        case .drizzler
//        return ""
//        }
//    }
// }
