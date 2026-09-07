//
//  AppRootView.swift
//  Sialbo-watchOS Watch App
//
//  학교/일과 설정 여부에 따라 온보딩/시간표 전환
//

import SwiftUI

struct AppRootView: View {
    @State private var school: School?
    @State private var grade: Int?
    @State private var classNumber: Int?
    @State private var scheduleSettings: ScheduleSettings?

    init() {
        let store = UserSettingsStore.shared
        _school = State(initialValue: store.school)
        _grade = State(initialValue: store.grade)
        _classNumber = State(initialValue: store.classNumber)
        _scheduleSettings = State(initialValue: store.scheduleSettings)
    }

    var body: some View {
        if let school, let grade, let classNumber, let scheduleSettings {
            TimetableView(school: school, grade: grade, classNumber: classNumber, scheduleSettings: scheduleSettings)
        } else if let school, let grade, let classNumber {
            ScheduleSetupFlowView { settings in
                UserSettingsStore.shared.saveSchedule(settings)
                scheduleSettings = settings
            }
        } else {
            SchoolSetupFlowView { school, grade, classNumber in
                UserSettingsStore.shared.saveSchool(school, grade: grade, classNumber: classNumber)
                self.school = school
                self.grade = grade
                self.classNumber = classNumber
            }
        }
    }
}

#Preview {
    AppRootView()
}
