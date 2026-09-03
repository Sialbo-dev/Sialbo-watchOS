//
//  SchoolConfirmView.swift
//  Sialbo-watchOS Watch App
//
//  선택 학교 확인
//

import SwiftUI

struct SchoolConfirmView: View {
    let school: School
    @Binding var path: [OnboardingRoute]

    var body: some View {
        Button("TODO: \(school.name) 확인") {
            path.append(.classPicker(school))
        }
    }
}

#Preview {
    SchoolConfirmView(
        school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울 효성구 어쩌구 어쩌로"),
        path: .constant([])
    )
}
