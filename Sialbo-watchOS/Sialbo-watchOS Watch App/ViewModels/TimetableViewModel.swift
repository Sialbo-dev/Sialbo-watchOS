//
//  TimetableViewModel.swift
//  Sialbo-watchOS Watch App
//
//  선택된 날짜의 시간표 조회 및 다음 교시 계산
//

import Foundation
import Observation

@Observable
final class TimetableViewModel {
    var schedulesByDate: [Date: DaySchedule] = [:]
    var isLoading = false
}
