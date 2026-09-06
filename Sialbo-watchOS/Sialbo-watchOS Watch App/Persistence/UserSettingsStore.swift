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
        static let schoolName = "schoolName"
        static let schoolAddress = "schoolAddress"
        static let grade = "grade"
        static let classNumber = "classNumber"
        static let scheduleSettings = "scheduleSettings"
    }

    var school: School? {
        guard let officeCode = defaults.string(forKey: Key.officeCode),
              let schoolCode = defaults.string(forKey: Key.schoolCode),
              let name = defaults.string(forKey: Key.schoolName),
              let address = defaults.string(forKey: Key.schoolAddress)
        else { return nil }
        return School(officeCode: officeCode, schoolCode: schoolCode, name: name, address: address)
    }

    var grade: Int? {
        let value = defaults.integer(forKey: Key.grade)
        return value == 0 ? nil : value
    }

    var classNumber: Int? {
        let value = defaults.integer(forKey: Key.classNumber)
        return value == 0 ? nil : value
    }

    var scheduleSettings: ScheduleSettings? {
        guard let data = defaults.data(forKey: Key.scheduleSettings) else { return nil }
        return try? JSONDecoder().decode(ScheduleSettings.self, from: data)
    }

    func saveSchool(_ school: School, grade: Int, classNumber: Int) {
        defaults.set(school.officeCode, forKey: Key.officeCode)
        defaults.set(school.schoolCode, forKey: Key.schoolCode)
        defaults.set(school.name, forKey: Key.schoolName)
        defaults.set(school.address, forKey: Key.schoolAddress)
        defaults.set(grade, forKey: Key.grade)
        defaults.set(classNumber, forKey: Key.classNumber)
    }

    func saveSchedule(_ settings: ScheduleSettings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: Key.scheduleSettings)
    }
}
