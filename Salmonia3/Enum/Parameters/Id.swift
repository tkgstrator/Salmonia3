//
//  Id.swift
//  Salmonia3
//
//  Created by devonly on 2022/02/25.
//

import SplatNet2

extension WeaponType {
	var id: Double {
		switch self {
		case .randomGold:
			return -2
		case .randomGreen:
			return -1
		case .shooterShort:
			return 0
		case .shooterFirst:
			return 10
		case .shooterPrecision:
			return 20
		case .shooterBlaze:
			return 30
		case .shooterNormal:
			return 40
		case .shooterGravity:
			return 50
		case .shooterQuickMiddle:
			return 60
		case .shooterExpert:
			return 70
		case .shooterHeavy:
			return 80
		case .shooterLong:
			return 90
		case .shooterBlasterShort:
			return 200
		case .shooterBlasterMiddle:
			return 210
		case .shooterBlasterLong:
			return 220
		case .shooterBlasterLightShort:
			return 230
		case .shooterBlasterLight:
			return 240
		case .shooterBlasterLightLong:
			return 250
		case .shooterTripleQuick:
			return 300
		case .shooterTripleMiddle:
			return 310
		case .shooterFlash:
			return 400
		case .rollerCompact:
			return 1000
		case .rollerNormal:
			return 1010
		case .rollerHeavy:
			return 1020
		case .rollerHunter:
			return 1030
		case .rollerBrushMini:
			return 1100
		case .rollerBrushNormal:
			return 1110
		case .chargerQuick:
			return 2000
		case .chargerNormal:
			return 2010
		case .chargerNormalScope:
			return 2020
		case .chargerLong:
			return 2030
		case .chargerLongScope:
			return 2040
		case .chargerLight:
			return 2050
		case .chargerKeeper:
			return 2060
		case .slosherStrong:
			return 3000
		case .slosherDiffusion:
			return 3010
		case .slosherLauncher:
			return 3020
		case .slosherBathtub:
			return 3030
		case .slosherWashtub:
			return 3040
		case .spinnerQuick:
			return 4000
		case .spinnerStandard:
			return 4010
		case .spinnerHyper:
			return 4020
		case .spinnerDownpour:
			return 4030
		case .spinnerSerein:
			return 4040
		case .twinsShort:
			return 5000
		case .twinsNormal:
			return 5010
		case .twinsGallon:
			return 5020
		case .twinsDual:
			return 5030
		case .twinsStepper:
			return 5040
		case .umbrellaNormal:
			return 6000
		case .umbrellaWide:
			return 6010
		case .umbrellaCompact:
			return 6020
		case .shooterBlasterBurst:
			return 20000
		case .umbrellaAutoAssault:
			return 20010
		case .chargerSpark:
			return 20020
		case .slosherVase:
			return 20030
		default:
			return 0
		}
	}

}

