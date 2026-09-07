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
    @State private var isSearching = false

    private let apiClient = NEISAPIClient()

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

                if isSearching {
                    ProgressView()
                } else {
                    TextField("학교 이름", text: $query)
                        .onSubmit(handleSearch)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 0)
            .padding(.bottom, 17)
        }
    }

    private func handleSearch() {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            path.append(.notFound)
            return
        }

        isSearching = true
        Task {
            defer { isSearching = false }
            let schools = (try? await apiClient.searchSchools(query: trimmed)) ?? []
            if schools.isEmpty {
                path.append(.notFound)
            } else {
                path.append(.searchResults(schools))
            }
        }
    }
}

#Preview {
    SchoolSearchPromptView(path: .constant([]))
}
