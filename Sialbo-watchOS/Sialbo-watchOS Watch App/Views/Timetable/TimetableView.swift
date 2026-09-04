//
//  TimetableView.swift
//  Sialbo-watchOS Watch App
//

import SwiftUI

struct TimetableView: View {
    let school: School
    let schedules: [DaySchedule]

    @State private var selectedIndex = 0
    @State private var sheet: TimetableSheet?
    @AppStorage("hasSeenSwipeGuide") private var hasSeenSwipeGuide = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                ForEach(schedules.indices, id: \.self) { index in
                    DayTimetableView(
                        schedule: schedules[index],
                        onChangeClass: { sheet = .changeClass },
                        onChangeSchool: { sheet = .changeSchool }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .sheet(item: $sheet) { sheet in
                switch sheet {
                case .changeClass:
                    ClassChangeFlowView(school: school)
                case .changeSchool:
                    SchoolSetupFlowView()
                }
            }

            if !hasSeenSwipeGuide {
                SwipeGuideOverlay {
                    hasSeenSwipeGuide = true
                }
            }
        }
    }
}

private enum TimetableSheet: Identifiable {
    case changeClass
    case changeSchool

    var id: Self { self }
}

private struct ClassChangeFlowView: View {
    let school: School
    @State private var path: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            ClassPickerView(school: school, path: $path)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    switch route {
                    case .classPickerInvalid:
                        ClassPickerInvalidView(path: $path)
                    default:
                        EmptyView()
                    }
                }
        }
    }
}

private struct DayTimetableView: View {
    let schedule: DaySchedule
    var onChangeClass: () -> Void
    var onChangeSchool: () -> Void

    @State private var showsMenu = false

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
                        showsMenu = true
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .frame(width: 32, height: 32)
                    .confirmationDialog("", isPresented: $showsMenu) {
                        Button("학급 변경", action: onChangeClass)
                        Button("학교 변경", action: onChangeSchool)
                    }

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
    TimetableView(
        school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울특별시 서초구 효령로 197"),
        schedules: DaySchedule.sampleWeek
    )
}
