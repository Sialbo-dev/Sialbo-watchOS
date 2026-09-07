//
//  SchoolKind.swift
//  Sialbo-watchOS Watch App
//
//  학교급별로 시간표 API 엔드포인트(els/mis/hisTimetable)가 다르므로
//  학교기본정보 API의 SCHUL_KND_SC_NM 응답을 검색 시점에 매핑해 저장
//

import Foundation

enum SchoolKind: String, Codable {
    case elementary
    case middle
    case high

    init?(neisSchoolKindName: String) {
        switch neisSchoolKindName {
        case "초등학교":
            self = .elementary
        case "중학교":
            self = .middle
        case "고등학교":
            self = .high
        default:
            return nil
        }
    }

    var classDurationMinutes: Int {
        switch self {
        case .elementary: return 40
        case .middle: return 45
        case .high: return 50
        }
    }

    var breakDurationMinutes: Int { 10 }
}
