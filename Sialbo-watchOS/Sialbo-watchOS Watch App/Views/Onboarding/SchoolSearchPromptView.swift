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
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                LogoHeaderView()

                Spacer()
                    .frame(height: 31)

                Text("학교를 선택해주세요")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 70.5)

                Button("확인") {
                    path.append(.searchResults)
                }
                .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
    }
}   

#Preview {
    SchoolSearchPromptView(path: .constant([]))
}
