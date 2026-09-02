//
//  SchoolSearchPromptView.swift
//  Sialbo-watchOS Watch App
//
//  학교 검색 진입
//

import SwiftUI

struct SchoolSearchPromptView: View {
    @Binding var path: [OnboardingRoute]

    var body: some View {
        Button("TODO: 학교를 선택해주세요") {
            path.append(.searchResults)
        }
    }
}

#Preview {
    SchoolSearchPromptView(path: .constant([]))
}
