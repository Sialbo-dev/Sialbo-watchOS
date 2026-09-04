//
//  TimetableHeaderView.swift
//  Sialbo-watchOS Watch App
//
//  시간표 화면 상단 로고 + 학급/학교 변경 메뉴
//

import SwiftUI

struct TimetableHeaderView: View {
    var title: String = "시얼보"
    var onChangeClass: () -> Void
    var onChangeSchool: () -> Void

    @State private var showsMenu = false

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea(edges: .top)

            LogoHeaderView(title: title)

            HStack {
                Button {
                    showsMenu = true
                } label: {
                    Image(systemName: "ellipsis")
                }
                .buttonStyle(.glass)
                .buttonBorderShape(.circle)
                .frame(width: 32, height: 32)
                .confirmationDialog("", isPresented: $showsMenu) {
                    Button("학급 변경", action: onChangeClass)
                    Button("학교 변경", action: onChangeSchool)
                }

                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 40)
        .offset(y: -45)
        .padding(.bottom, -45)
    }
}

#Preview {
    TimetableHeaderView(onChangeClass: {}, onChangeSchool: {})
}
