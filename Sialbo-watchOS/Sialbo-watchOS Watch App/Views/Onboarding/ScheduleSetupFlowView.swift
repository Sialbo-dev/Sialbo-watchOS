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

    @State private var dayStartHour: Int
    @State private var dayStartMinute: Int
    @State private var lunchStartHour: Int
    @State private var lunchStartMinute: Int
    @State private var lunchEndHour: Int
    @State private var lunchEndMinute: Int

    @State private var lunchStartError: String?
    @State private var lunchEndError: String?

    init(initial: ScheduleSettings? = nil, onFinish: @escaping (ScheduleSettings) -> Void) {
        self.onFinish = onFinish
        _dayStartHour = State(initialValue: initial?.dayStartTime.hour ?? 9)
        _dayStartMinute = State(initialValue: initial?.dayStartTime.minute ?? 0)
        _lunchStartHour = State(initialValue: initial?.lunchStartTime.hour ?? 12)
        _lunchStartMinute = State(initialValue: initial?.lunchStartTime.minute ?? 0)
        _lunchEndHour = State(initialValue: initial?.lunchEndTime.hour ?? 13)
        _lunchEndMinute = State(initialValue: initial?.lunchEndTime.minute ?? 0)
    }

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
                    TimePickerView(title: "점심시간 시작 시간", hour: $lunchStartHour, minute: $lunchStartMinute, errorMessage: lunchStartError) {
                        guard minutes(lunchStartHour, lunchStartMinute) > minutes(dayStartHour, dayStartMinute) else {
                            lunchStartError = "1교시 시작 시간보다 늦어야 해요."
                            return
                        }
                        lunchStartError = nil
                        path.append(.lunchEnd)
                    }
                case .lunchEnd:
                    TimePickerView(title: "점심시간 종료 시간", hour: $lunchEndHour, minute: $lunchEndMinute, errorMessage: lunchEndError) {
                        guard minutes(lunchEndHour, lunchEndMinute) > minutes(lunchStartHour, lunchStartMinute) else {
                            lunchEndError = "점심시간 시작 시간보다 늦어야 해요."
                            return
                        }
                        lunchEndError = nil
                        path.append(.complete)
                    }
                case .complete:
                    ScheduleCompleteView {
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

    private func minutes(_ hour: Int, _ minute: Int) -> Int {
        hour * 60 + minute
    }
}

#Preview {
    ScheduleSetupFlowView { _ in }
}
