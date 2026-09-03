//
//  ClassPickerInvalidView.swift
//  Sialbo-watchOS Watch App
//
//  학년-반 형식 오류
//

import SwiftUI

struct ClassPickerInvalidView: View {
    @Binding var path: [OnboardingRoute]

    var body: some View {
        ErrorRetryView(
            message: "올바르지 않은 형식이에요.",
            onRetry: {
                path.removeLast()
            },
            messageTopPadding: 20
        )
    }
}

#Preview {
    ClassPickerInvalidView(path: .constant([]))
}
