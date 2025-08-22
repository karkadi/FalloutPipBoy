//
//  RootView.swift
//  FalloutPipBoy
//
//  Created by Arkadiy KAZAZYAN on 25/08/2025.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            PipBoyView()
            RotatingSecondsView()
            TimeCircuitsView()
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
    }
}

#Preview {
    RootView()
}
