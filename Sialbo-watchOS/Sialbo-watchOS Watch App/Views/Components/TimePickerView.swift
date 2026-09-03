//
//  TimePickerView.swift
//  Sialbo-watchOS Watch App
//
//  시:분 휠 피커, 안내 문구 + 확인 버튼
//

import SwiftUI

struct TimePickerView: View {
    let title: String
    @Binding var hour: Int
    @Binding var minute: Int
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()

            VStack {
                Text(title)
                    .font(.griun(16))
                    .foregroundStyle(.titleYellow)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)

                Spacer()
                    .frame(height: 15)

                HStack(spacing: 8) {
                    Picker("시", selection: $hour) {
                        ForEach(0..<24, id: \.self) { hour in
                            Text(String(format: "%02d", hour))
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width: 50, height: 60)

                    Text(":")
                        .font(.griun(16))
                        .frame(height: 60)

                    Picker("분", selection: $minute) {
                        ForEach(0..<60, id: \.self) { minute in
                            Text(String(format: "%02d", minute))
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .frame(width: 50, height: 60)
                }

                Spacer()
                    .frame(height: 15)

                Spacer()

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
    TimePickerView(title: "1교시 시작 시간", hour: .constant(9), minute: .constant(0)) {}
}
