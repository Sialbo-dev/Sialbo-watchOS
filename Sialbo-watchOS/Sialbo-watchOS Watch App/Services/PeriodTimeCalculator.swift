//
//  PeriodTimeCalculator.swift
//  Sialbo-watchOS Watch App
//
//  교시 시간 계산

import Foundation

enum PeriodTimeCalculator {
    static func periods(
        from rawPeriods: [(periodNumber: Int, subject: String)],
        date: Date,
        scheduleSettings: ScheduleSettings,
        kind: SchoolKind
    ) -> [Period] {
        let calendar = Calendar.current

        func time(_ components: DateComponents) -> Date {
            calendar.date(
                bySettingHour: components.hour ?? 0,
                minute: components.minute ?? 0,
                second: 0,
                of: date
            )!
        }

        let lunchStart = time(scheduleSettings.lunchStartTime)
        let lunchEnd = time(scheduleSettings.lunchEndTime)
        let classDuration = TimeInterval(kind.classDurationMinutes * 60)
        let breakDuration = TimeInterval(kind.breakDurationMinutes * 60)

        var currentStart = time(scheduleSettings.dayStartTime)
        var periods: [Period] = []

        for rawPeriod in rawPeriods.sorted(by: { $0.periodNumber < $1.periodNumber }) {
            let periodEnd = currentStart.addingTimeInterval(classDuration)
            periods.append(
                Period(
                    periodNumber: rawPeriod.periodNumber,
                    subject: rawPeriod.subject,
                    startTime: currentStart,
                    endTime: periodEnd
                )
            )

            let breakEnd = periodEnd.addingTimeInterval(breakDuration)
            if periodEnd < lunchStart && breakEnd > lunchStart {
                currentStart = lunchEnd
            } else {
                currentStart = breakEnd
            }
        }

        return periods
    }
}
