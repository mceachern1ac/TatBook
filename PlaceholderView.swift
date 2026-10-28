//
//  PlaceholderView.swift
//  TatBook
//
//  Created by Aubri McEachern on 12/20/25.
//

import Foundation
import SwiftUI

struct PlaceholderView: View {
    let title: String
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "wrench")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("\(title) Coming Soon")
                .font(.title2)
                .padding()
            Spacer()
        }
    }
}
