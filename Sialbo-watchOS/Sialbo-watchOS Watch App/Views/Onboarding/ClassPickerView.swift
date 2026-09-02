//
//  ClassPickerView.swift
//  Sialbo-watchOS Watch App
//
//  학년-반 휠 피커
//

import SwiftUI

struct ClassPickerView: View {
    let school: School
    @Binding var path: [OnboardingRoute]

    var body: some View {
        Text("TODO: \(school.name) 학년-반 선택")
    }
}

#Preview {
    ClassPickerView(
        school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교"),
        path: .constant([])
    )
}
