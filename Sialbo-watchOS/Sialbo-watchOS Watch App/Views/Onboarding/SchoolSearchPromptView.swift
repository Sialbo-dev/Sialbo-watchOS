//
//  SchoolSearchPromptView.swift
//  Sialbo-watchOS Watch App
//
//  학교 검색 진입
//

import SwiftUI

struct SchoolSearchPromptView: View {
    @Binding var path: [OnboardingRoute]

    @State private var query = ""

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                LogoHeaderView()
                    .padding(.top, 20)

                Spacer()
                    .frame(height: 28)

                Text("학교를 선택해주세요")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 35)

                TextField("학교 이름", text: $query)
                    .onSubmit {
                        // TODO: NEISAPIClient 연동 후 결과에 따라 분기
                        path.append(.searchResults)
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 0)
            .padding(.bottom, 17)
        }
    }
}   

#Preview {
    SchoolSearchPromptView(path: .constant([]))
}
