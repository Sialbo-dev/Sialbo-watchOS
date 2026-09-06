//
//  AppRootView.swift
//  Sialbo-watchOS Watch App
//
//  학교/일과 설정 여부에 따라 온보딩/시간표 전환
//

import SwiftUI

struct AppRootView: View {
    @State private var school: School?
    @State private var scheduleSettings: ScheduleSettings?

    init() {
        _school = State(initialValue: UserSettingsStore.shared.school)
        _scheduleSettings = State(initialValue: UserSettingsStore.shared.scheduleSettings)
    }

    var body: some View {
        if let school, let scheduleSettings {
            TimetableView(school: school, schedules: DaySchedule.sampleWeek)
        } else if let school {
            ScheduleSetupFlowView { settings in
                UserSettingsStore.shared.saveSchedule(settings)
                scheduleSettings = settings
            }
        } else {
            SchoolSetupFlowView { school, grade, classNumber in
                UserSettingsStore.shared.saveSchool(school, grade: grade, classNumber: classNumber)
                self.school = school
            }
        }
    }
}

#Preview {
    AppRootView()
}
