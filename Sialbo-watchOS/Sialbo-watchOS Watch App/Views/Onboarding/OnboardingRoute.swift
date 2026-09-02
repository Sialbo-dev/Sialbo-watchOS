//
//  OnboardingRoute.swift
//  Sialbo-watchOS Watch App
//
//  학교 설정 플로우 화면 목록, NavigationStack path 원소
//

import Foundation

enum OnboardingRoute: Hashable {
    case searchResults
    case notFound
    case confirm(School)
    case classPicker(School)
    case classPickerInvalid
}
