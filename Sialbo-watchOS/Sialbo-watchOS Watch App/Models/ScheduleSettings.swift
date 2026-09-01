//
//  ScheduleSettings.swift
//  Sialbo-watchOS Watch App
//
//  사용자가 직접 입력하는 일과 시간표 기준값
//  (일과 시작 시간 < 점심시간 시작 < 점심시간 종료)
//

import Foundation

struct ScheduleSettings: Codable, Hashable {
    var dayStartTime: DateComponents   // 일과 시작 시간
    var lunchStartTime: DateComponents // 점심시간 시작
    var lunchEndTime: DateComponents   // 점심시간 종료
}
