//
//  SchoolSetupFlowView.swift
//  Sialbo-watchOS Watch App
//
//  학교 설정 플로우 루트, path 배열 기준 push/pop
//

import SwiftUI

struct SchoolSetupFlowView: View {
    let onComplete: (School, Int, Int) -> Void

    @State private var path: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            SchoolSearchPromptView(path: $path)
                .navigationDestination(for: OnboardingRoute.self) { route in
                    switch route {
                    case .searchResults(let schools):
                        SchoolSearchResultsView(path: $path, schools: schools)
                    case .notFound:
                        SchoolNotFoundView(path: $path)
                    case .confirm(let school):
                        SchoolConfirmView(school: school, path: $path)
                    case .classPicker(let school):
                        ClassPickerView(school: school, path: $path) { grade, classNumber in
                            onComplete(school, grade, classNumber)
                        }
                    case .classPickerInvalid:
                        ClassPickerInvalidView(path: $path)
                    }
                }
        }
    }
}

#Preview {
    SchoolSetupFlowView { _, _, _ in }
}
