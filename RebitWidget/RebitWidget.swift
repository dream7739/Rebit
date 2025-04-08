//
//  RebitWidget.swift
//  RebitWidget
//
//  Created by 홍정민 on 4/7/25.
//

import WidgetKit
import SwiftUI

// 위젯의 화면 표시를 업데이트할 시기를 알려줌
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // 현 시각이후 1시간씩 5개의 타임라인 존재
        // policy로 마지막 시간 이후 다시 타임라인을 생성되도록 함
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

// 위젯 랜더링 시 보여질 View
struct RebitWidgetEntryView : View {
    var entry: Provider.Entry
    let favoriteReview = RealmManager.shared.getLatestFavoriteReview()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let favoriteReview {
                Text("오늘의 한줄🐰")
                    .font(.callout)
                    .bold()
                Text(favoriteReview.title)
                    .font(.callout)
                Text("from. \(favoriteReview.book.first!.title)")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                Text("리빗에 독서기록을 저장해보세요🐰")
                    .font(.callout)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Kind: 위젯을 식별하는 아이디
// Provider: 위젯을 새로고침할 타임라인
// 클로저 내부: EntriyView 포함(위젯이 랜더링되는 뷰)
struct RebitWidget: Widget {
    let kind: String = "RebitWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RebitWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RebitWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("리빗")
        .description("리빗에 기록한 독서기록을 확인해보세요")
        .supportedFamilies([.systemSmall, .systemMedium]) // 지원 크기
    }
}

#Preview(as: .systemSmall) {
    RebitWidget()
} timeline: {
    SimpleEntry(date: .now)
    SimpleEntry(date: .now)
}
