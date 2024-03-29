//
//  shiftwidget.swift
//  shiftwidget
//
//  Created by devonly on 2021/08/31.
//  Copyright © 2021 Magi Corporation. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> ShiftSchedule {
        return ShiftSchedule(date: WidgetManager.shared.getLatestShiftScheduleDate(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ShiftSchedule) -> ()) {
        let entry = ShiftSchedule(date: WidgetManager.shared.getLatestShiftScheduleDate(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeIntervalSince1970 = Int(Date().timeIntervalSince1970)
        let currentTime: Date = Date(timeIntervalSince1970: Double(timeIntervalSince1970 - timeIntervalSince1970 % 60))
        let entryDate: [Date] = (0 ... 1).compactMap{( Calendar.current.date(byAdding: .minute, value: $0, to: currentTime) )}
        let entries: [ShiftSchedule] = entryDate.map({ ShiftSchedule(date: $0, configuration: ConfigurationIntent())})
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ShiftSchedule: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let schedule: Schedule
    let remindTime: String
    let isScheduleHeld: Bool
    
    init(date currentTime: Date, configuration: ConfigurationIntent) {
        self.date = currentTime
        self.configuration = configuration
        self.schedule = WidgetManager.shared.getLatestShiftSchedule(currentTime: currentTime)

        // 差分を計算
        if currentTime >= schedule.startTime {
            // 開催中
            let reminder = Calendar(identifier: .gregorian).dateComponents([.second], from: currentTime, to: schedule.endTime)
            self.remindTime = WidgetManager.shared.formatter.string(from: reminder)!
            self.isScheduleHeld = true
        } else {
            // 開催待ち
            let reminder = Calendar(identifier: .gregorian).dateComponents([.second], from: currentTime, to: schedule.startTime)
            self.remindTime = WidgetManager.shared.formatter.string(from: reminder)!
            self.isScheduleHeld = false
        }
    }
}

struct shiftwidgetEntryView : View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy MM/dd HH:mm"
        return formatter
    }()
    
    var entry: Provider.Entry
    
    var body: some View {
//        Text("Nyamo")
        Image(stageId: entry.schedule.stageId)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(
                LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 50, maximum: 50)), count: 4), alignment: .center, spacing: 10, pinnedViews: [], content: {
                    ForEach(entry.schedule.weaponList.indices) { index in
                        Image(weaponId: entry.schedule.weaponList[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(4)
                            .background(Circle().fill(Color.black.opacity(0.8)))
                    }
                })
                .offset(x: 0, y: 30)
            )
            .overlay(
                VStack(alignment: .center, spacing: 4, content: {
                    Text(dateFormatter.string(from: entry.schedule.startTime))
                        .foregroundColor(.white)
                        .font(.custom("Splatfont2", size: 20))
                        .shadow(color: .black, radius: 0, x: 3, y: 3)
                        .offset(x: 0, y: 20)
                    Text(entry.remindTime)
                        .font(.custom("Splatfont2", size: 16))
                        .shadow(color: .black, radius: 0, x: 3, y: 3)
                        .foregroundColor(entry.isScheduleHeld ? .white : .red.opacity(0.3))
                }),
                alignment: .top
            )
            .overlay(
                VStack(alignment: .center, spacing: nil, content: {
                    Text(entry.isScheduleHeld ? "Open" : "Close")
                        .foregroundColor(.white)
                        .font(.custom("Splatfont2", size: 16))
                        .frame(height: 24)
                        .padding(.horizontal, 6)
                        .background(Capsule().fill(Color.red))
                        .offset(x: -10, y: 20)
                }),
                alignment: .topTrailing
            )
    }
}

@main
struct shiftwidget: Widget {
    let kind: String = "shiftwidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            shiftwidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Salmonia3")
        .description("テイオーかわいいよくばりパック")
        .supportedFamilies([.systemMedium])
    }
}

struct shiftwidget_Previews: PreviewProvider {
    static var previews: some View {
        shiftwidgetEntryView(entry: ShiftSchedule(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
