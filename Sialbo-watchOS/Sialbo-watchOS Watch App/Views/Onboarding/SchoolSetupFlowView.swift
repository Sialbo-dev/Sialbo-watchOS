//
//  SchoolSetupFlowView.swift
//  Sialbo-watchOS Watch App
//
//  학교 설정 플로우 루트, path 배열 기준 push/pop
//

import SwiftUI

struct SchoolSetupFlowView: View {
    @State private var path: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            SchoolSearchPromptView(path: $path)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    switch route {
                    case .searchResults:
                        SchoolSearchResultsView(
                            path: $path,
                            schools: [
                                School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울특별시 서초구 효령로 197"),
                                School(officeCode: "B10", schoolCode: "7010570", name: "서울고등학교", address: "서울특별시 서초구 우와아앙로"),
                            ]
                        )
                    case .notFound:
                        SchoolNotFoundView(path: $path)
                    case .confirm(let school):
                        SchoolConfirmView(school: school, path: $path)
                    case .classPicker(let school):
                        ClassPickerView(school: school, path: $path)
                    case .classPickerInvalid:
                        ClassPickerInvalidView(path: $path)
                    }
                }
        }
    }
}

#Preview {
    SchoolSetupFlowView()
}
