//
//  GroceryList_IOS_Widget.swift
//  GroceryList_IOS Widget
//
//  Created by Aditi Saini on 2022-08-06.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), item1: "", item2:"", item3: "", configuration: ConfigurationIntent())
        
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), item1: "", item2:"", item3: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    
        
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            var favItem:String = ""
            if let userDefaults = UserDefaults(suiteName: "group.ca.singhs.grocerylist-ios") {
                           favItem = userDefaults.string(forKey: "fav") ?? "N/A"
                       }

            
            var entry = SimpleEntry(date: entryDate, item1: favItem, item2:"", item3:"", configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var item1: String
    let item2: String
    let item3: String
    let configuration: ConfigurationIntent
}

struct GroceryList_IOS_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 10){
        Text("Favourite List")
        Text("Don't forget")
        Text(entry.item1)
        }
    }
}

@main
struct GroceryList_IOS_Widget: Widget {
    let kind: String = "GroceryList_IOS_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GroceryList_IOS_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct GroceryList_IOS_Widget_Previews: PreviewProvider {
    static var previews: some View {
        GroceryList_IOS_WidgetEntryView(entry: SimpleEntry(date: Date(),item1: "", item2:"", item3: "", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
