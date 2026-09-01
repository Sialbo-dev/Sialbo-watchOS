//
//  SchoolSetupViewModel.swift
//  Sialbo-watchOS Watch App
//
//  학교/학급 검색 및 선택을 담당
//

import Foundation
import Observation

@Observable
final class SchoolSetupViewModel {
    var searchResults: [School] = []
    var selectedSchool: School?
}
