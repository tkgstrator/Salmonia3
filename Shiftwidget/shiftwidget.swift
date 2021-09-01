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
        return ShiftSchedule(date: WidgetManager.shared.schedules.first!.startTime, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ShiftSchedule) -> ()) {
        let entry = ShiftSchedule(date: WidgetManager.shared.schedules.first!.startTime, configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [ShiftSchedule] = WidgetManager.shared.schedulesTime.map({ ShiftSchedule(date: $0, configuration: ConfigurationIntent()) })
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct ShiftSchedule: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let schedule: Schedule
    
    init(date: Date, configuration: ConfigurationIntent) {
        self.date = date
        self.configuration = configuration
        self.schedule = WidgetManager.shared.schedules.filter({ $0.startTime == date }).first!
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
                            .background(Circle().fill(Color.black))
                    }
                })
                .offset(x: 0, y: 30)
            )
            .overlay(
                Text(dateFormatter.string(from: entry.schedule.startTime))
                    .font(.custom("Splatfont2", size: 20))
                    .shadow(color: .black, radius: 0, x: 3, y: 3)
                    .offset(x: 0, y: 30),
                alignment: .top
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
