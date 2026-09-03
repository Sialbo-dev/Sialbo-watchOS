//
//  ErrorRetryView.swift
//  Sialbo-watchOS Watch App
//
//  에러 문구 + 다시 시도 버튼
//

import SwiftUI

struct ErrorRetryView: View {
    let message: String
    let onRetry: () -> Void
    var onDismiss: (() -> Void)? = nil
    var messageTopPadding: CGFloat = 0

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            if let onDismiss {
                VStack {
                    HStack {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.glass)
                        .buttonBorderShape(.circle)
                        .frame(width: 34, height: 34)

                        Spacer()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }

            VStack {
                Text(message)
                    .font(.griun(15))
                    .foregroundStyle(.errorOrange)
                    .multilineTextAlignment(.center)
                    .padding(.top, messageTopPadding)

                Spacer()

                Button("다시 시도", action: onRetry)
                    .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 0)
            .padding(.bottom, -2)
        }
    }
}

#Preview {
    ErrorRetryView(message: "올바르지 않은 형식이에요.") {}
}

#Preview("닫기 버튼 포함") {
    ErrorRetryView(message: "학교를 찾을 수 없어요.", onRetry: {}, onDismiss: {})
}
