//
//  UserSettingsStore.swift
//  Sialbo-watchOS Watch App
//
//  선택한 학교(교육청 코드 + 학교 코드)와 학급, 일과 시간표 기준값을 저장
//

import Foundation

@MainActor
final class UserSettingsStore {
    static let shared = UserSettingsStore()

    private let defaults = UserDefaults.standard

    private enum Key {
        static let officeCode = "officeCode"
        static let schoolCode = "schoolCode"
        static let grade = "grade"
        static let classNumber = "classNumber"
    }

    var officeCode: String? {
        get { defaults.string(forKey: Key.officeCode) }
        set { defaults.set(newValue, forKey: Key.officeCode) }
    }

    var schoolCode: String? {
        get { defaults.string(forKey: Key.schoolCode) }
        set { defaults.set(newValue, forKey: Key.schoolCode) }
    }
}
