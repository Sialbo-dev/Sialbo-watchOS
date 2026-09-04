//
//  ScheduleCompleteView.swift
//  Sialbo-watchOS Watch App
//
//  일과 정보 입력 완료
//

import SwiftUI

struct ScheduleCompleteView: View {
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                LogoHeaderView()
                    .padding(.top, 5)

                Spacer()
                    .frame(height: 35)

                Text("설정을 완료했어요!")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 6)

                Text("위젯으로도 사용해보세요")
                    .font(.griun(13))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()
                    .frame(height: 33)

                Button("확인", action: onConfirm)
                    .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 0)
            .padding(.bottom, 3)
        }
    }
}

#Preview {
    ScheduleCompleteView {}
}
