//
//  TopBar.swift
//  TatBook
//
//  Created by Aubri McEachern on 12/21/25.
//

import Foundation
import SwiftUI

struct TopBar: View {
    var onPlus: () -> Void
    var onChat: () -> Void

    var body: some View {
        HStack {
            Button(action: onPlus) {
                Image(systemName: "plus")
                    .font(.title2)
                    .padding()
            }
            Spacer()
            Text("TATBOOK")
                .font(.headline)
                .italic()
                .kerning(2)
            Spacer()
            Button(action: onChat) {
                Image(systemName: "bubble.left")
                    .font(.title2)
                    .padding()
            }
        }
        .padding(.horizontal)
        .frame(height: 44)
        .background(.ultraThinMaterial)
    }
}
