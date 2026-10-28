//
//  shimmerbackground.swift
//  AubriPersonalCopy
//
//  Created by Aubri McEachern on 11/20/25.
//

import Foundation
import SwiftUI

struct ShimmerBackground: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            // Travel far enough that the rotated gradient fully exits the screen.
            // 2x width is a safe margin for a ~20° rotation.
            let travel: CGFloat = width * 2.0

            ZStack {
                // Your base color/wave
                Color.darkGreen
                    .ignoresSafeArea()

                // The shimmer gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.0008),
                        Color.white.opacity(0.02),
                        Color.white.opacity(0.0008)
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .blendMode(.luminosity)
                .rotationEffect(.degrees(20))
                // Start well off the left, end well off the right
                .offset(x: animate ? travel : -travel)
                .animation(
                    .linear(duration: 1.8).repeatForever(autoreverses: false),
                    value: animate
                )
            }
            .onAppear {
                // Kick off the infinite sweep
                animate = true
            }
        }
    }
}
