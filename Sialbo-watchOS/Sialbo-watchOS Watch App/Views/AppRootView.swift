//
//  AppRootView.swift
//  Sialbo-watchOS Watch App
//
//  일과 설정 여부에 따라 온보딩/시간표 전환
//

import SwiftUI

struct AppRootView: View {
    @State private var scheduleSettings: ScheduleSettings?

    var body: some View {
        if scheduleSettings != nil {
            TimetableView(
                school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울특별시 서초구 효령로 197"),
                schedules: DaySchedule.sampleWeek
            )
        } else {
            ScheduleSetupFlowView { settings in
                scheduleSettings = settings
            }
        }
    }
}

#Preview {
    AppRootView()
}
