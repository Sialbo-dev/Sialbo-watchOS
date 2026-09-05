//
//  SharedTimetableStore.swift
//  Sialbo-watchOS-Widget
//
//  App Group 공유 저장소, 앱 → 위젯 오늘 교시 정보 읽기
//

import Foundation

enum SharedTimetableStore {
    private static let suiteName = "group.juhui.Sialbo-watchOS"
    private static let key = "todayPeriods"

    static func load() -> [SharedPeriodInfo] {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return [] }
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([SharedPeriodInfo].self, from: data)) ?? []
    }
}
