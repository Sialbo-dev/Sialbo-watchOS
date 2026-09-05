//
//  SharedPeriodInfo.swift
//  Sialbo-watchOS Watch App
//
//  위젯과 공유하는 오늘 교시 정보
//

import Foundation

struct SharedPeriodInfo: Codable {
    let subject: String
    let startTime: Date
    let endTime: Date
}
