//
//  LogoHeaderView.swift
//  Sialbo-watchOS Watch App
//
//  화면 상단 로고 + 타이틀, 재사용 헤더
//

import SwiftUI

struct LogoHeaderView: View {
    var title: String = "시얼보"

    var body: some View {
        HStack(spacing: 4) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 19, height: 20)
            Text(title)
                .font(.griun(16))
                .foregroundStyle(.logoGold)
                .offset(y: 1)
        }
    }
}

#Preview {
    LogoHeaderView()
}
