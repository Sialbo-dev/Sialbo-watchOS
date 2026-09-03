//
//  TimetableView.swift
//  Sialbo-watchOS Watch App
//

import SwiftUI

struct TimetableView: View {
    let schedules: [DaySchedule]
    var onMenuTap: () -> Void

    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(schedules.indices, id: \.self) { index in
                DayTimetableView(schedule: schedules[index], onMenuTap: onMenuTap)
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
    }
}

private struct DayTimetableView: View {
    let schedule: DaySchedule
    var onMenuTap: () -> Void

    var body: some View {
        ScrollViewReader { proxy in
            List(schedule.periods) { period in
                PeriodRowView(period: period)
                    .listRowBackground(Color.clear)
                    .id(period.id)
            }
            .listStyle(.carousel)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let nextPeriod {
                        proxy.scrollTo(nextPeriod.id, anchor: .center)
                    }
                }
            }
        }
        .safeAreaInset(edge: .top) {
            ZStack {
                Color.black
                    .ignoresSafeArea(edges: .top)

                LogoHeaderView(title: headerTitle)

                HStack {
                    Button {
                        onMenuTap()
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .frame(width: 32, height: 32)

                    Spacer()
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 40)
            .offset(y: -45)
            .padding(.bottom, -45)
        }
    }

    private var nextPeriod: Period? {
        schedule.periods.first { $0.endTime > .now } ?? schedule.periods.last
    }

    private var headerTitle: String {
        if Calendar.current.isDateInToday(schedule.date) {
            return "시얼보"
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: schedule.date)
    }
}

private struct PeriodRowView: View {
    let period: Period

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(period.periodNumber)교시")
                .font(.griun(11))
            Text(period.subject)
                .font(.griun(16))
            Text(timeRange)
                .font(.griun(12))
        }
        .foregroundStyle(.primary)
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.periodHighlight)
        .clipShape(RoundedRectangle(cornerRadius: 8.5))
    }

    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        return "\(formatter.string(from: period.startTime)) - \(formatter.string(from: period.endTime))"
    }
}

#Preview {
    TimetableView(schedules: DaySchedule.sampleWeek) {}
}
