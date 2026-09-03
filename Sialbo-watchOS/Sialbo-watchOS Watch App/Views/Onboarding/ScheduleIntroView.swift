//
//  ScheduleIntroView.swift
//  Sialbo-watchOS Watch App
//
//  일과 정보 입력 안내
//

import SwiftUI

struct ScheduleIntroView: View {
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                Text("다음 수업을\n미리 알려드릴게요")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)

                Spacer()
                    .frame(height: 12)

                Text("교시 시간을 계산하기 위해\n3가지 일과 정보를 알려주세요.")
                    .font(.griun(13))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)

                Spacer()

                Button("확인", action: onConfirm)
                    .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 0)
            .padding(.bottom, -10)
        }
    }
}

#Preview {
    ScheduleIntroView {}
}
