//
//  RealmCoopPlayer.swift
//  Salmonia3
//
//  Created by devonly on 2021/10/20.
//

import Foundation
import RealmSwift
import SalmonStats
import SplatNet2

final class RealmCoopPlayer: Object, ObjectKeyIdentifiable {
    @Persisted var name: String?
    @Persisted(indexed: true) var pid: String
    @Persisted var deadCount: Int
    @Persisted var helpCount: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var ikuraNum: Int
    @Persisted var specialId: SpecialId
    @Persisted var bossKillCounts: List<Int>
    @Persisted var weaponList: List<WeaponType>
    @Persisted var specialCounts: List<Int>
    @Persisted(originProperty: "player") var link: LinkingObjects<RealmCoopResult>
    
    public convenience init(dummy: Bool = false) {
        self.init()
        self.name = "ああああああああああ"
        self.pid = "0000000000000000"
        self.deadCount = 99
        self.helpCount = 99
        self.goldenIkuraNum = 999
        self.ikuraNum = 9999
        self.specialId = .inkjet
        self.bossKillCounts.append(objectsIn: Array(repeating: 0, count: 9))
        self.weaponList.append(objectsIn: Array(repeating: .chargerSpark, count: 3))
        self.specialCounts.append(objectsIn: [0, 0, 0])
    }
    
    public convenience init(from result: FSCoopPlayer) {
        self.init()
        self.name = result.name
        self.pid = result.pid
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.specialId = SpecialId(rawValue: result.special)!
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.weaponList.append(objectsIn: result.weaponList.compactMap({ WeaponType(rawValue: $0) }))
        self.specialCounts.append(objectsIn: result.specialCounts)
    }
    
    public convenience init(from result: CoopResult.PlayerResult) {
        self.init()
        self.name = result.name
        self.pid = result.pid
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.specialId = result.special.id
        self.bossKillCounts.append(objectsIn: result.bossKillCounts.sortedValue())
        self.weaponList.append(objectsIn: result.weaponList.map({ $0.weaponId }))
        self.specialCounts.append(objectsIn: result.specialCounts)
    }
}

extension RealmCoopPlayer {
    var result: RealmCoopResult {
        link.first!
    }
}


extension SpecialId: PersistableEnum {
}

extension CoopResult.WeaponList {
    var weaponId: WeaponType {
        switch self.id {
        case .randomGold:
            return .randomGold
        case .randomGreen:
            return .randomGreen
        case .shooterShort:
            return .shooterShort
        case .shooterFirst:
            return .shooterFirst
        case .shooterPrecision:
            return .shooterPrecision
        case .shooterBlaze:
            return .shooterBlaze
        case .shooterNormal:
            return .shooterNormal
        case .shooterGravity:
            return .shooterGravity
        case .shooterQuickMiddle:
            return .shooterQuickMiddle
        case .shooterExpert:
            return .shooterExpert
        case .shooterHeavy:
            return .shooterHeavy
        case .shooterLong:
            return .shooterLong
        case .shooterBlasterShort:
            return .shooterBlasterShort
        case .shooterBlasterMiddle:
            return .shooterBlasterMiddle
        case .shooterBlasterLong:
            return .shooterBlasterLong
        case .shooterBlasterLightShort:
            return .shooterBlasterLightShort
        case .shooterBlasterLight:
            return .shooterBlasterLight
        case .shooterBlasterLightLong:
            return .shooterBlasterLightLong
        case .shooterTripleQuick:
            return .shooterTripleQuick
        case .shooterTripleMiddle:
            return .shooterTripleMiddle
        case .shooterFlash:
            return .shooterFlash
        case .rollerCompact:
            return .rollerCompact
        case .rollerNormal:
            return .rollerNormal
        case .rollerHeavy:
            return .rollerHeavy
        case .rollerHunter:
            return .rollerHunter
        case .rollerBrushMini:
            return .rollerBrushMini
        case .rollerBrushNormal:
            return .rollerBrushNormal
        case .chargerQuick:
            return .chargerQuick
        case .chargerNormal:
            return .chargerNormal
        case .chargerNormalScope:
            return .chargerNormalScope
        case .chargerLong:
            return .chargerLong
        case .chargerLongScope:
            return .chargerLongScope
        case .chargerLight:
            return .chargerLight
        case .chargerKeeper:
            return .chargerKeeper
        case .slosherStrong:
            return .slosherStrong
        case .slosherDiffusion:
            return .slosherDiffusion
        case .slosherLauncher:
            return .slosherLauncher
        case .slosherBathtub:
            return .slosherBathtub
        case .slosherWashtub:
            return .slosherWashtub
        case .spinnerQuick:
            return .spinnerQuick
        case .spinnerStandard:
            return .spinnerStandard
        case .spinnerHyper:
            return .spinnerHyper
        case .spinnerDownpour:
            return .spinnerDownpour
        case .spinnerSerein:
            return .spinnerSerein
        case .twinsShort:
            return .twinsShort
        case .twinsNormal:
            return .twinsNormal
        case .twinsGallon:
            return .twinsGallon
        case .twinsDual:
            return .twinsDual
        case .twinsStepper:
            return .twinsStepper
        case .umbrellaNormal:
            return .umbrellaNormal
        case .umbrellaWide:
            return .umbrellaWide
        case .umbrellaCompact:
            return .umbrellaCompact
        case .shooterBlasterBurst:
            return .shooterBlasterBurst
        case .umbrellaAutoAssault:
            return .umbrellaAutoAssault
        case .chargerSpark:
            return .chargerSpark
        case .slosherVase:
            return .slosherVase
        }
    }
}

extension RealmCoopPlayer {
    /// Nintendo Switch Onlineの画像
    //    var thumbnailURL: URL {
    //        RealmManager.shared.thumbnailURL(playerId: self.pid)
    //    }
    
    /// 自身が操作したプレイヤーかどうかのフラグ
    var isControlled: Bool {
        guard let firstPlayer = self.result.player.first else { return false }
        return firstPlayer.pid == self.pid
    }
    
    var matchingCount: Int {
        realm?.playerResults(nsaid: self.pid).count ?? 1
    }
}

extension RealmCoopPlayer: Identifiable {
    var id: String { self.pid }
}
