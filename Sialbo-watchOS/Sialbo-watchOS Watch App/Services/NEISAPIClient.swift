//
//  NEISAPIClient.swift
//  Sialbo-watchOS Watch App
//
//  나이스 교육정보 개방포털 Open API 호출
//

import Foundation

struct NEISAPIClient {
    func searchSchools(query: String) async throws -> [School] {
        []
    }

    func fetchTimetable(school: School, grade: String, classNumber: String, date: Date) async throws -> DaySchedule {
        DaySchedule(date: date, periods: [])
    }
}
