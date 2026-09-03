//
//  SchoolSearchResultsView.swift
//  Sialbo-watchOS Watch App
//
//  검색 결과 리스트
//

import SwiftUI

struct SchoolSearchResultsView: View {
    @Binding var path: [OnboardingRoute]

    let schools: [School]

    var body: some View {
        List(schools) { school in
            Button {
                path.append(.confirm(school))
            } label: {
                VStack(alignment: .leading) {
                    Text(school.name)
                        .font(.griun(16))
                    Text(school.address)
                        .font(.footnote)
                        .lineLimit(1)
                }
            }
            .listItemTint(.periodHighlight)
        }
    }
}

#Preview {
    SchoolSearchResultsView(
        path: .constant([]),
        schools: [
            School(officeCode: "B10", schoolCode: "7010569", name: "서울고등학교", address: "서울특별시 서초구 효령로 197"),
            School(officeCode: "B10", schoolCode: "7010570", name: "서울고등학교", address: "서울특별시 서초구 우와아앙로"),
        ]
    )
}
