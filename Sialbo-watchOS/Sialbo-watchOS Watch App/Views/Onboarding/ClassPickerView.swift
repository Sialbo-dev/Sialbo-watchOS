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
    let onConfirm: (Int, Int) -> Void

    @State private var grade = 1
    @State private var classNumber = 1
    @State private var isChecking = false

    private let apiClient = NEISAPIClient()

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                Text("학년-반 선택")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)
                    .padding(.top, 3)

                Spacer()
                    .frame(height: 8)

                HStack(spacing: 8) {
                    Picker("학년", selection: $grade) {
                        ForEach(1...6, id: \.self) { grade in
                            Text("\(grade)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 50, height: 60)

                    Picker("반", selection: $classNumber) {
                        ForEach(1...20, id: \.self) { classNumber in
                            Text("\(classNumber)")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 50, height: 60)
                }

                Spacer()
                    .frame(height: 20)

                Button("선택") {
                    handleConfirm()
                }
                .buttonStyle(.glass)
                .disabled(isChecking)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal,0)
            .padding(.bottom, 3)
        }
    }

    private func handleConfirm() {
        isChecking = true
        Task {
            defer { isChecking = false }
            let week = NEISAPIClient.currentWeekRange()
            let rawPeriods = (try? await apiClient.fetchRawTimetable(
                school: school,
                grade: grade,
                classNumber: classNumber,
                from: week.from,
                to: week.to
            )) ?? []

            if rawPeriods.isEmpty {
                path.append(.classPickerInvalid)
            } else {
                onConfirm(grade, classNumber)
            }
        }
    }
}

#Preview {
    ClassPickerView(
        school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울 효성구 어쩌구 어쩌로", kind: .high),
        path: .constant([]),
        onConfirm: { _, _ in }
    )
}
