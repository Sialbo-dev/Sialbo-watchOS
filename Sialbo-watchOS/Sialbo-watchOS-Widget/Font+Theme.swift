//
//  Font+Theme.swift
//  Sialbo-watchOS-Widget
//
//  Griun Mongtori 브랜드 서체, 위젯 타깃 전용
//

import SwiftUI

extension Font {
    static func griun(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        .custom("Griun Mongtori", size: size, relativeTo: textStyle)
    }
}
