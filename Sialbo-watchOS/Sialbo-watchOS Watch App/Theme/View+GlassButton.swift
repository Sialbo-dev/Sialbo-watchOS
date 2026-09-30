//
//  View+GlassButton.swift
//  Sialbo-watchOS Watch App
//
//  watchOS 26 이상은 글래스, 이전 버전은 bordered 버튼 스타일
//

import SwiftUI

extension View {
    @ViewBuilder
    func glassButtonStyle() -> some View {
        if #available(watchOS 26, *) {
            buttonStyle(.glass)
        } else {
            buttonStyle(.bordered)
        }
    }
}
