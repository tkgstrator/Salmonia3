extension WeaponType {
	var range: Double {
		switch self {
		case .randomGold:
			return 0
		case .randomGreen:
			return 0
		case .shooterShort:
			return 22
		case .shooterFirst:
			return 36
		case .shooterPrecision:
			return 38
		case .shooterBlaze:
			return 36
		case .shooterNormal:
			return 42
		case .shooterGravity:
			return 46
		case .shooterQuickMiddle:
			return 42
		case .shooterExpert:
			return 58
		case .shooterHeavy:
			return 58
		case .shooterLong:
			return 78
		case .shooterBlasterShort:
			return 27
		case .shooterBlasterMiddle:
			return 38
		case .shooterBlasterLong:
			return 52
		case .shooterBlasterLightShort:
			return 36
		case .shooterBlasterLight:
			return 59
		case .shooterBlasterLightLong:
			return 69
		case .shooterTripleQuick:
			return 50
		case .shooterTripleMiddle:
			return 58
		case .shooterFlash:
			return 72
		case .rollerCompact:
			return 32
		case .rollerNormal:
			return 46
		case .rollerHeavy:
			return 68
		case .rollerHunter:
			return 51
		case .rollerBrushMini:
			return 22
		case .rollerBrushNormal:
			return 36
		case .chargerQuick:
			return 66
		case .chargerNormal:
			return 94
		case .chargerNormalScope:
			return 102
		case .chargerLong:
			return 114
		case .chargerLongScope:
			return 122
		case .chargerLight:
			return 76
		case .chargerKeeper:
			return 74
		case .slosherStrong:
			return 50
		case .slosherDiffusion:
			return 38
		case .slosherLauncher:
			return 56
		case .slosherBathtub:
			return 82
		case .slosherWashtub:
			return 74
		case .spinnerQuick:
			return 50
		case .spinnerStandard:
			return 74
		case .spinnerHyper:
			return 90
		case .spinnerDownpour:
			return 90
		case .spinnerSerein:
			return 62
		case .twinsShort:
			return 28
		case .twinsNormal:
			return 42
		case .twinsGallon:
			return 56
		case .twinsDual:
			return 58
		case .twinsStepper:
			return 46
		case .umbrellaNormal:
			return 42
		case .umbrellaWide:
			return 54
		case .umbrellaCompact:
			return 42
		case .shooterBlasterBurst:
			return 44
		case .umbrellaAutoAssault:
			return 42
		case .chargerSpark:
			return 114
		case .slosherVase:
			return 82
		default:
			return 0
		}
	}

}

