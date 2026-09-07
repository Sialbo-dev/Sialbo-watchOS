//
//  TimetableView.swift
//  Sialbo-watchOS Watch App
//

import SwiftUI

struct TimetableView: View {
    @State private var school: School
    @State private var grade: Int
    @State private var classNumber: Int
    @State private var scheduleSettings: ScheduleSettings

    @State private var schedules: [DaySchedule]?
    @State private var loadFailed = false
    @State private var selectedIndex = 0
    @State private var sheet: TimetableSheet?
    @AppStorage("hasSeenSwipeGuide") private var hasSeenSwipeGuide = false
    @Environment(\.scenePhase) private var scenePhase

    private let apiClient = NEISAPIClient()

    init(school: School, grade: Int, classNumber: Int, scheduleSettings: ScheduleSettings) {
        _school = State(initialValue: school)
        _grade = State(initialValue: grade)
        _classNumber = State(initialValue: classNumber)
        _scheduleSettings = State(initialValue: scheduleSettings)
    }

    var body: some View {
        Group {
            if let schedules {
                ZStack {
                    TabView(selection: $selectedIndex) {
                        ForEach(Array(schedules.enumerated()), id: \.element.id) { index, schedule in
                            DayTimetableView(
                                schedule: schedule,
                                onChangeClass: { sheet = .changeClass },
                                onChangeSchool: { sheet = .changeSchool }
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page)

                    if !hasSeenSwipeGuide {
                        SwipeGuideOverlay {
                            hasSeenSwipeGuide = true
                        }
                    }
                }
                .onAppear { saveTodayPeriodsForWidget(schedules) }
            } else if loadFailed {
                TimetableLoadErrorView(
                    onRetry: { Task { await loadTimetable() } },
                    onChangeClass: { sheet = .changeClass },
                    onChangeSchool: { sheet = .changeSchool }
                )
            } else {
                ProgressView()
            }
        }
        .sheet(item: $sheet) { activeSheet in
            switch activeSheet {
            case .changeClass:
                ClassChangeFlowView(school: school) { newGrade, newClassNumber in
                    UserSettingsStore.shared.saveSchool(school, grade: newGrade, classNumber: newClassNumber)
                    grade = newGrade
                    classNumber = newClassNumber
                    sheet = nil
                    Task { await loadTimetable() }
                }
            case .changeSchool:
                SchoolSetupFlowView { newSchool, newGrade, newClassNumber in
                    sheet = .newSchoolSchedule(newSchool, newGrade, newClassNumber)
                }
            case .newSchoolSchedule(let newSchool, let newGrade, let newClassNumber):
                ScheduleSetupFlowView { newScheduleSettings in
                    UserSettingsStore.shared.saveSchool(newSchool, grade: newGrade, classNumber: newClassNumber)
                    UserSettingsStore.shared.saveSchedule(newScheduleSettings)
                    school = newSchool
                    grade = newGrade
                    classNumber = newClassNumber
                    scheduleSettings = newScheduleSettings
                    sheet = nil
                    Task { await loadTimetable() }
                }
            }
        }
        .task { await loadTimetable() }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await loadTimetable() }
            }
        }
    }

    private var todayIndex: Int {
        schedules?.firstIndex { Calendar.current.isDateInToday($0.date) } ?? 0
    }

    private func loadTimetable() async {
        let week = NEISAPIClient.currentWeekRange()
        do {
            schedules = try await apiClient.fetchTimetable(
                school: school,
                grade: grade,
                classNumber: classNumber,
                from: week.from,
                to: week.to,
                scheduleSettings: scheduleSettings
            )
            loadFailed = false
            selectedIndex = todayIndex
        } catch {
            schedules = nil
            loadFailed = true
        }
    }

    private func saveTodayPeriodsForWidget(_ schedules: [DaySchedule]) {
        let today = schedules.first { Calendar.current.isDateInToday($0.date) }
        let periods = (today?.periods ?? []).map {
            SharedPeriodInfo(subject: $0.subject, startTime: $0.startTime, endTime: $0.endTime)
        }
        SharedTimetableStore.save(periods)
    }
}

private enum TimetableSheet: Identifiable, Hashable {
    case changeClass
    case changeSchool
    case newSchoolSchedule(School, Int, Int)

    var id: Self { self }
}

private struct ClassChangeFlowView: View {
    let school: School
    let onConfirm: (Int, Int) -> Void

    @State private var path: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            ClassPickerView(school: school, path: $path, onConfirm: onConfirm)
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
            TimetableHeaderView(title: headerTitle, onChangeClass: onChangeClass, onChangeSchool: onChangeSchool)
        }
    }

    private var nextPeriod: Period? {
        guard Calendar.current.isDateInToday(schedule.date) else {
            return schedule.periods.first
        }
        return schedule.periods.first { $0.endTime > .now } ?? schedule.periods.last
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
        school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울특별시 서초구 효령로 197", kind: .high),
        grade: 2,
        classNumber: 3,
        scheduleSettings: ScheduleSettings(
            dayStartTime: DateComponents(hour: 9, minute: 0),
            lunchStartTime: DateComponents(hour: 12, minute: 30),
            lunchEndTime: DateComponents(hour: 13, minute: 30)
        )
    )
}
