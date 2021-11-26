//
//  ShiftView.swift
//  Salmonia3
//
//  Created by devonly on 2021/11/26.
//

import SwiftUI
import SplatNet2

struct ShiftView: View {
    @Environment(\.shiftSchedule) var shift
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 30, maximum: 50)), count: 4), alignment: .center, spacing: nil, pinnedViews: [], content: {
            ForEach(shift.weaponList) { weapon in
                Image(weapon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        })
    }
}

struct ShiftView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftView()
    }
}

extension WeaponType: Identifiable {
    public var id: Int { rawValue }
}

extension Image {
    init(_ weaponType: WeaponType) {
        self.init("Weapon/\(weaponType.rawValue)", bundle: .main)
    }
}

class EnvironmentValue {
    struct CoopShift: EnvironmentKey {
        static var defaultValue: RealmCoopShift = RealmCoopShift()
        
        typealias Value = RealmCoopShift
    }
}

extension EnvironmentValues {
    var shiftSchedule: RealmCoopShift {
        get {
            self[EnvironmentValue.CoopShift.self]
        }
        set {
            self[EnvironmentValue.CoopShift.self] = newValue
        }
    }
}
