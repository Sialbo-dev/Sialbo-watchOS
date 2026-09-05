//
//  Sialbo_watchOS_Widget.swift
//  Sialbo-watchOS-Widget
//
//  Created by 신주희 on 9/5/26.
//

import WidgetKit
import SwiftUI

enum WidgetContent {
    case period(subject: String, timeRangeText: String)
    case noMorePeriods
    case unavailable
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, content: .period(subject: "확률과 통계", timeRangeText: "11:40 - 12:30"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let periods = SharedTimetableStore.load().sorted { $0.startTime < $1.startTime }
        let now = Date()
        let next = periods.first { $0.startTime > now }
        completion(SimpleEntry(date: now, content: content(for: next, hasAnyPeriods: !periods.isEmpty)))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let periods = SharedTimetableStore.load().sorted { $0.startTime < $1.startTime }
        let now = Date()
        // "다음 교시"는 아직 시작 안 한 교시만 해당 — 지금 진행 중인 교시는 다음이 아니라 현재임
        let future = periods.filter { $0.startTime > now }

        var entries: [SimpleEntry] = []
        entries.append(SimpleEntry(date: now, content: content(for: future.first, hasAnyPeriods: !periods.isEmpty)))

        // future[i]가 시작하는 순간, "다음 교시"는 future[i+1]로 바뀜 (없으면 다음 교시 없음)
        for index in future.indices {
            let nextAfter = index + 1 < future.count ? future[index + 1] : nil
            entries.append(SimpleEntry(date: future[index].startTime, content: content(for: nextAfter, hasAnyPeriods: !periods.isEmpty)))
        }

        completion(Timeline(entries: entries, policy: .atEnd))
    }

    private func content(for period: SharedPeriodInfo?, hasAnyPeriods: Bool) -> WidgetContent {
        guard let period else {
            return hasAnyPeriods ? .noMorePeriods : .unavailable
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        let timeRangeText = "\(formatter.string(from: period.startTime)) - \(formatter.string(from: period.endTime))"
        return .period(subject: period.subject, timeRangeText: timeRangeText)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let content: WidgetContent
}

struct Sialbo_watchOS_WidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("다음교시")
                .font(.griun(11))
                .lineLimit(1)

            switch entry.content {
            case .period(let subject, let timeRangeText):
                Text(subject)
                    .font(.griun(20))
                    .lineLimit(1)
                    .padding(.top, 1)
                Text(timeRangeText)
                    .font(.griun(12))
                    .lineLimit(1)
            case .noMorePeriods:
                Text("다음 교시가 없어요")
                    .font(.griun(16))
                    .lineLimit(1)
                    .padding(.top, 1)
                Text("오늘 수업이 끝났어요")
                    .font(.griun(12))
                    .lineLimit(1)
            case .unavailable:
                Text("시간표 조회 실패")
                    .font(.griun(20))
                    .lineLimit(1)
                    .padding(.top, 1)
                Text("다시 확인해주세요")
                    .font(.griun(12))
                    .lineLimit(1)
            }
        }
        .foregroundStyle(Color(white: 0.95))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Sialbo_watchOS_Widget: Widget {
    let kind = "Sialbo_watchOS_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Sialbo_watchOS_WidgetEntryView(entry: entry)
                .containerBackground(Color("PeriodHighlight"), for: .widget)
        }
        .configurationDisplayName("시얼보")
        .description("다음 수업을 확인하세요")
        .supportedFamilies([.accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    Sialbo_watchOS_Widget()
} timeline: {
    SimpleEntry(date: .now, content: .period(subject: "논술", timeRangeText: "11:30 - 12:30"))
    SimpleEntry(date: .now, content: .noMorePeriods)
    SimpleEntry(date: .now, content: .unavailable)
}
