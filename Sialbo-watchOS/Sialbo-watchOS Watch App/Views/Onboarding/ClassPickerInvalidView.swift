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
        Text("TODO: 올바르지 않은 형식입니다")
    }
}

#Preview {
    ClassPickerInvalidView(path: .constant([]))
}
