//
//  Weapon.swift
//  Salmonia3
//
//  Created by devonly on 2021/09/02.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum IconWeapon: String, CaseIterable {
    public enum Package {
        public static let namespace = "Weapon"
        public static let version = "1.0.0"
    }
    
    case randomGold                 = "-2"
    case randomGreen                = "-1"
    case shooterShort               = "0"
    case shooterFirst               = "10"
    case shooterPrecision           = "20"
    case shooterBlaze               = "30"
    case shooterNormal              = "40"
    case shooterGravity             = "50"
    case shooterQuickMiddle         = "60"
    case shooterExpert              = "70"
    case shooterHeavy               = "80"
    case shooterLong                = "90"
    case shooterBlasterShort        = "200"
    case shooterBlasterMiddle       = "210"
    case shooterBlasterLong         = "220"
    case shooterBlasterLightShort   = "230"
    case shooterBlasterLight        = "240"
    case shooterBlasterLightLong    = "250"
    case shooterTripleQuick         = "300"
    case shooterTripleMiddle        = "310"
    case shooterFlash               = "400"
    case rollerCompact              = "1000"
    case rollerNormal               = "1010"
    case rollerHeavy                = "1020"
    case rollerHunter               = "1030"
    case rollerBrushMini            = "1100"
    case rollerBrushNormal          = "1110"
    case chargerQuick               = "2000"
    case chargerNormal              = "2010"
    case chargerNormalScope         = "2020"
    case chargerLong                = "2030"
    case chargerLongScope           = "2040"
    case chargerLight               = "2050"
    case chargerKeeper              = "2060"
    case slosherStrong              = "3000"
    case slosherDiffusion           = "3010"
    case slosherLauncher            = "3020"
    case slosherBathtub             = "3030"
    case slosherWashtub             = "3040"
    case spinnerQuick               = "4000"
    case spinnerStandard            = "4010"
    case spinnerHyper               = "4020"
    case spinnerDownpour            = "4030"
    case spinnerSerein              = "4040"
    case twinsShort                 = "5000"
    case twinsNormal                = "5010"
    case twinsGallon                = "5020"
    case twinsDual                  = "5030"
    case twinsStepper               = "5040"
    case umbrellaNormal             = "6000"
    case umbrellaWide               = "6010"
    case umbrellaCompact            = "6020"

    public var imageName: String {
        "\(Package.namespace)/\(rawValue)"
    }
}

extension Image {
    init(_ symbol: IconStage) {
        self.init(symbol.imageName, bundle: .main)
    }

    init(_ symbol: IconWeapon) {
        self.init(symbol.imageName, bundle: .main)
    }

    init(stageId: Int) {
        self.init(IconStage(rawValue: String(stageId))!)
    }
    
    init(weaponId: Int) {
        print(weaponId)
        self.init(IconWeapon(rawValue: String(weaponId))!)
    }
}
