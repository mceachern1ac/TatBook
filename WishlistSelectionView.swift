//
//  WishlistSelectionView.swift
//  TatBook
//
//  Created by Aubri McEachern on 12/22/25.
//

import Foundation
import SwiftUI

struct Wishlist: Identifiable {
    let id = UUID()
    let name: String
    let dateRange: String
    let savedCount: Int
    let imageName: String
}

let sampleWishlists = [
    Wishlist(name: "Conventions", dateRange: "2026", savedCount: 5, imageName: "sample1"),
    Wishlist(name: "Workshops", dateRange: "2026", savedCount: 11, imageName: "sample2"),
    Wishlist(name: "Shops", dateRange: "2026", savedCount: 3, imageName: "sample3"),
]

struct WishlistSelectionView: View {
    var onSelect: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Add to wishlist")
                .font(.title2).bold()
                .padding(.top)
                .foregroundColor(Color("FontColor"))
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem()], spacing: 18) {
                    ForEach(sampleWishlists) { wishlist in
                        Button(action: onSelect) {
                            VStack(alignment: .leading, spacing: 4) {
                                Image(wishlist.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 165, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                                    )
                                Text(wishlist.name)
                                    .font(.headline)
                                    .foregroundColor(Color("FontColor"))
                                Text(wishlist.dateRange)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(wishlist.savedCount) saved")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(8)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            Button(action: {
                // Handle create new wishlist
                onSelect()
            }) {
                Text("Create new wishlist")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(Color("FontColor"))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: .black.opacity(0.09), radius: 8, y: 2)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GreenGreen"), Color.white.opacity(0.38)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
        )
    }
}
#Preview("Wishlist Selection") {
    WishlistSelectionView(onSelect: {})
}
