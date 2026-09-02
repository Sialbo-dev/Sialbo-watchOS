//
//  SchoolNotFoundView.swift
//  Sialbo-watchOS Watch App
//
//  검색 결과 없음 에러
//

import SwiftUI

struct SchoolNotFoundView: View {
    @Binding var path: [OnboardingRoute]

    var body: some View {
        Text("TODO: 학교를 찾을 수 없습니다")
    }
}

#Preview {
    SchoolNotFoundView(path: .constant([]))
}
