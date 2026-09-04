//
//  SwipeGuideOverlay.swift
//  Sialbo-watchOS Watch App
//
//  좌우 스와이프 안내 코치마크
//

import SwiftUI

struct SwipeGuideOverlay: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 22))
                    .foregroundStyle(.titleYellow)

                Text("좌우 스와이프로\n요일 변경")
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                Spacer()
            }
        }
        .onTapGesture {
            onDismiss()
        }
    }
}

#Preview {
    SwipeGuideOverlay {}
}
