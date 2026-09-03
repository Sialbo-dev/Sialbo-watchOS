//
//  ScheduleSetupFlowView.swift
//  Sialbo-watchOS Watch App
//
//  일과 정보 입력 플로우 루트, path 배열 기준 push/pop
//

import SwiftUI

struct ScheduleSetupFlowView: View {
    let onFinish: (ScheduleSettings) -> Void

    @State private var path: [ScheduleSetupRoute] = []

    @State private var dayStartHour = 9
    @State private var dayStartMinute = 0
    @State private var lunchStartHour = 12
    @State private var lunchStartMinute = 0
    @State private var lunchEndHour = 13
    @State private var lunchEndMinute = 0

    var body: some View {
        NavigationStack(path: $path) {
            ScheduleIntroView {
                path.append(.dayStart)
            }
            .navigationDestination(for: ScheduleSetupRoute.self) { route in
                switch route {
                case .dayStart:
                    TimePickerView(title: "1교시 시작 시간", hour: $dayStartHour, minute: $dayStartMinute) {
                        path.append(.lunchStart)
                    }
                case .lunchStart:
                    TimePickerView(title: "점심시간 시작 시간", hour: $lunchStartHour, minute: $lunchStartMinute) {
                        path.append(.lunchEnd)
                    }
                case .lunchEnd:
                    TimePickerView(title: "점심시간 종료 시간", hour: $lunchEndHour, minute: $lunchEndMinute) {
                        onFinish(
                            ScheduleSettings(
                                dayStartTime: DateComponents(hour: dayStartHour, minute: dayStartMinute),
                                lunchStartTime: DateComponents(hour: lunchStartHour, minute: lunchStartMinute),
                                lunchEndTime: DateComponents(hour: lunchEndHour, minute: lunchEndMinute)
                            )
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ScheduleSetupFlowView { _ in }
}
