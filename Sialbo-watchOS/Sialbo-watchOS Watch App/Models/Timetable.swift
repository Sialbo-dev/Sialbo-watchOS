//
//  Timetable.swift
//  Sialbo-watchOS Watch App
//

import Foundation

struct Period: Identifiable, Hashable {
    let id = UUID()
    let periodNumber: Int
    let subject: String
    let startTime: Date
    let endTime: Date
}

struct DaySchedule: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let periods: [Period]
}

extension DaySchedule {
    static var sampleWeek: [DaySchedule] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        func time(_ hour: Int, _ minute: Int, dayOffset: Int) -> Date {
            let day = calendar.date(byAdding: .day, value: dayOffset, to: today)!
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day)!
        }

        return (0..<3).map { dayOffset in
            DaySchedule(
                date: calendar.date(byAdding: .day, value: dayOffset, to: today)!,
                periods: [
                    Period(periodNumber: 1, subject: "확률과 통계", startTime: time(9, 0, dayOffset: dayOffset), endTime: time(9, 50, dayOffset: dayOffset)),
                    Period(periodNumber: 2, subject: "영어2", startTime: time(10, 0, dayOffset: dayOffset), endTime: time(10, 50, dayOffset: dayOffset)),
                    Period(periodNumber: 3, subject: "컴퓨터네트워크", startTime: time(11, 0, dayOffset: dayOffset), endTime: time(11, 50, dayOffset: dayOffset)),
                    Period(periodNumber: 4, subject: "확률과 통계", startTime: time(11, 40, dayOffset: dayOffset), endTime: time(12, 30, dayOffset: dayOffset)),
                    Period(periodNumber: 5, subject: "체육", startTime: time(13, 30, dayOffset: dayOffset), endTime: time(14, 20, dayOffset: dayOffset)),
                    Period(periodNumber: 6, subject: "한국사", startTime: time(14, 30, dayOffset: dayOffset), endTime: time(15, 20, dayOffset: dayOffset)),
                    Period(periodNumber: 7, subject: "미술", startTime: time(15, 30, dayOffset: dayOffset), endTime: time(16, 20, dayOffset: dayOffset)),
                ]
            )
        }
    }
}
