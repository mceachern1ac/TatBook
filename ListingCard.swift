import Foundation
import SwiftUI

struct ListingCard: View {
    let listing: Listing
    
    var body: some View {
        VStack(spacing: 8) {
            Image(listing.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(alignment: .topLeading) {
                    Text(listing.tag)
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Capsule())
                        .padding(8)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(listing.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(listing.price)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ListingCard(listing: Listing(
        title: "Sample Shop",
        price: "$150/day",
        imageName: "tattooer3",
        tag: "Guest favorite",
        latitude: 37.7749,
        longitude: -122.4194
    ))
}
