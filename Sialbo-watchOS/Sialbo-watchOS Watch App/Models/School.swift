//
//  School.swift
//  Sialbo-watchOS Watch App
//

import Foundation

struct School: Identifiable, Hashable {
    var id: String { schoolCode }
    let officeCode: String   // 교육청 코드 (ATPT_OFCDC_SC_CODE)
    let schoolCode: String   // 학교 코드 (SD_SCHUL_CODE)
    let name: String
}
