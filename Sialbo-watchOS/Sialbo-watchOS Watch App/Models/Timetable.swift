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
