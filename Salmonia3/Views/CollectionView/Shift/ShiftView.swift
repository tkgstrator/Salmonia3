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
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack(content: {
            Group(content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.startTime))))
                    Text(verbatim: "-")
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(shift.endTime))))
                })
                Text(shift.stageName)
            })
                .foregroundColor(.white)
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 30, maximum: 50)), count: 4), alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(shift.weaponList.indices) { index in
                    Image(shift.weaponList[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(2)
                        .background(Circle().fill(.black.opacity(0.9)))
                }
            })
        })
            .background(
                Image(shift.stageId)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(Rectangle().fill(.black.opacity(0.5)).padding(.bottom, 70))
                    .cornerRadius(10)
            )
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
    
    init(_ stageId: Schedule.StageId) {
        self.init("Stage/\(stageId.rawValue)", bundle: .main)
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
