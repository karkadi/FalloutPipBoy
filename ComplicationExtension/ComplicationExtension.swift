//
//  ComplicationExtension.swift
//  ComplicationExtension
//
//  Created by Arkadiy KAZAZYAN on 17/08/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct ComplicationExtensionEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .accessoryCircular:
            Gauge(value: Double(42), in: 0...100) {
                Text("1")
            } currentValueLabel: {
                Text("1")
              //  Text(entry.date, style: .timer)
            }
            
        case .accessoryRectangular:
            VStack {
                HStack {
                    Text("Time:")
                    Text(entry.date, style: .time)
                }
                
                Text("Emoji:")
                Text(entry.emoji)
            }
        default:
            Text(entry.date, style: .time)
        }
    }
}

struct ComplicationExtension: Widget {
    let kind: String = "ComplicationExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                ComplicationExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ComplicationExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .accessoryRectangular) {
    ComplicationExtension()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
}

#Preview(as: .accessoryCircular) {
    ComplicationExtension()
} timeline: {
    SimpleEntry(date: .now, emoji: "🤩")
}
