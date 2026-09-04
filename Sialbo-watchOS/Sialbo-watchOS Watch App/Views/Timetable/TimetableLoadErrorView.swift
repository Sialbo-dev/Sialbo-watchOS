//
//  TimetableLoadErrorView.swift
//  Sialbo-watchOS Watch App
//
//  시간표 조회 실패
//

import SwiftUI

struct TimetableLoadErrorView: View {
    var onRetry: () -> Void
    var onChangeClass: () -> Void
    var onChangeSchool: () -> Void

    @State private var showsMenu = false

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                LogoHeaderView()
                    .padding(.top, 10)
                    .ignoresSafeArea(edges: .top)

                Spacer()
                    .frame(height: 35)

                Text("시간표를 불러오지 못했어요")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 6)

                Text("잠시 후 다시 시도해 주세요.")
                    .font(.griun(13))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 40)

                Button("확인", action: onRetry)
                    .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 0)
            .padding(.bottom, 3)
        }
        .overlay(alignment: .topLeading) {
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
            .padding(.top, 5)
            .padding(.leading, 8)
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    TimetableLoadErrorView(onRetry: {}, onChangeClass: {}, onChangeSchool: {})
}
