//
//  ContentView.swift
//  Sialbo-watchOS Watch App
//
//  Created by 신주희 on 9/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 4) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 23)
            Text("시얼보")
                .font(.griun(16))
                .foregroundStyle(.logoGold)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
