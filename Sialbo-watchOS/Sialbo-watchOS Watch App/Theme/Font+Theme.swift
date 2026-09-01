//
//  Font+Theme.swift
//  Sialbo-watchOS Watch App
//
//  Griun Mongtori 브랜드 서체. relativeTo로 Dynamic Type과 함께 스케일된다.
//

import SwiftUI

extension Font {
    static func griun(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        .custom("Griun Mongtori", size: size, relativeTo: textStyle)
    }
}
