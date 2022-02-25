extension WeaponType {
	var drizzlers: Double {
		switch self {
		case .randomGold:
			return 0
		case .randomGreen:
			return 0
		case .shooterShort:
			return 90
		case .shooterFirst:
			return 50
		case .shooterPrecision:
			return 65
		case .shooterBlaze:
			return 65
		case .shooterNormal:
			return 65
		case .shooterGravity:
			return 65
		case .shooterQuickMiddle:
			return 65
		case .shooterExpert:
			return 90
		case .shooterHeavy:
			return 80
		case .shooterLong:
			return 65
		case .shooterBlasterShort:
			return 65
		case .shooterBlasterMiddle:
			return 50
		case .shooterBlasterLong:
			return 50
		case .shooterBlasterLightShort:
			return 50
		case .shooterBlasterLight:
			return 65
		case .shooterBlasterLightLong:
			return 50
		case .shooterTripleQuick:
			return 80
		case .shooterTripleMiddle:
			return 80
		case .shooterFlash:
			return 90
		case .rollerCompact:
			return 65
		case .rollerNormal:
			return 50
		case .rollerHeavy:
			return 50
		case .rollerHunter:
			return 65
		case .rollerBrushMini:
			return 50
		case .rollerBrushNormal:
			return 50
		case .chargerQuick:
			return 90
		case .chargerNormal:
			return 90
		case .chargerNormalScope:
			return 90
		case .chargerLong:
			return 80
		case .chargerLongScope:
			return 80
		case .chargerLight:
			return 90
		case .chargerKeeper:
			return 50
		case .slosherStrong:
			return 35
		case .slosherDiffusion:
			return 50
		case .slosherLauncher:
			return 65
		case .slosherBathtub:
			return 90
		case .slosherWashtub:
			return 50
		case .spinnerQuick:
			return 80
		case .spinnerStandard:
			return 90
		case .spinnerHyper:
			return 90
		case .spinnerDownpour:
			return 100
		case .spinnerSerein:
			return 90
		case .twinsShort:
			return 90
		case .twinsNormal:
			return 80
		case .twinsGallon:
			return 80
		case .twinsDual:
			return 65
		case .twinsStepper:
			return 65
		case .umbrellaNormal:
			return 80
		case .umbrellaWide:
			return 65
		case .umbrellaCompact:
			return 65
		case .shooterBlasterBurst:
			return 65
		case .umbrellaAutoAssault:
			return 65
		case .chargerSpark:
			return 100
		case .slosherVase:
			return 90
		default:
			return 0
		}
	}

}

