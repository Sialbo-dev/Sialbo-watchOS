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
        ErrorRetryView(
            message: "학교를 찾을 수 없어요.",
            onRetry: {
                path = []
            },
            onDismiss: {
                path = []
            }
        )
    }
}

#Preview {
    SchoolNotFoundView(path: .constant([]))
}
