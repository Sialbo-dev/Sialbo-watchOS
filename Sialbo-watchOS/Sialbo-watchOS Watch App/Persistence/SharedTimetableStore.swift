//
//  SharedTimetableStore.swift
//  Sialbo-watchOS Watch App
//
//  App Group 공유 저장소, 앱 → 위젯 오늘 교시 정보 전달
//

import Foundation
import WidgetKit

enum SharedTimetableStore {
    private static let suiteName = "group.juhui.Sialbo-watchOS"
    private static let key = "todayPeriods"

    static func save(_ periods: [SharedPeriodInfo]) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        guard let data = try? JSONEncoder().encode(periods) else { return }
        defaults.set(data, forKey: key)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
