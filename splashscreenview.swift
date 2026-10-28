//
//  splashscreenview.swift
//  AubriPersonalCopy
//
//  Created by Aubri McEachern on 11/20/25.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @State private var animate = false
    @State private var showMainContent = false

    var body: some View {
        if showMainContent {
            ContentView() // Your main app view
        } else {
            ZStack {
                ShimmerBackground()
                VStack(spacing: 24) {
                    Image("logo_white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .opacity(animate ? 1 : 0.3)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
                        .ignoresSafeArea()
                }
            }
            .onAppear {
                animate = true
                // Show splash for 2 seconds, then show main content
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showMainContent = true
                    }
                }
            }
        }
    }
}
