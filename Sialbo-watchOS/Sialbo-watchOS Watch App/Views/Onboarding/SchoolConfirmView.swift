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
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                Text(school.name)
                    .font(.griun(20))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)

                Spacer()
                    .frame(height: 6)

                Text(school.address)
                    .font(.griun(12))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 36)

                HStack {
                    Button {
                        path.removeLast()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .frame(width: 34, height: 34)

                    Spacer()

                    Button {
                        path.append(.classPicker(school))
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .frame(width: 34, height: 34)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 7)
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    SchoolConfirmView(
        school: School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울특별시 서초구 효령로 197"),
        path: .constant([])
    )
}
