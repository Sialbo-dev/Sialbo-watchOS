//
//  SchoolSearchResultsView.swift
//  Sialbo-watchOS Watch App
//
//  검색 결과 리스트
//

import SwiftUI

struct SchoolSearchResultsView: View {
    @Binding var path: [OnboardingRoute]

    var body: some View {
        Button("TODO: 검색 결과 리스트") {
            path.append(.confirm(School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교")))
        }
    }
}

#Preview {
    SchoolSearchResultsView(path: .constant([]))
}
