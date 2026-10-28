import SwiftUI
internal import Combine

// NOTE: Placeholder models are compiled only when USE_FEED_PLACEHOLDERS is defined to avoid conflicts with app models.
#if USE_FEED_PLACEHOLDERS
// MARK: - Models and Sample Data to make this file compile standalone
enum ListingKind: String, CaseIterable, Identifiable, Codable {
    case shop
    case workshop
    case convention
    var id: String { rawValue }
}

struct Listing: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let location: String
    let distance: Double
    let date: Date
    let imageName: String?
    let handle: String?
    let businessName: String?
    let kind: ListingKind
}

let sampleListings: [Listing] = [
    Listing(id: UUID(), title: "Leather Craft Basics", location: "Downtown", distance: 2.4, date: Date().addingTimeInterval(3600 * 5), imageName: nil, handle: "@craftcorner", businessName: "Craft Corner", kind: .workshop),
    Listing(id: UUID(), title: "Indie Game Expo", location: "Convention Center", distance: 7.1, date: Date().addingTimeInterval(3600 * 30), imageName: nil, handle: nil, businessName: "IndieWorld", kind: .convention),
    Listing(id: UUID(), title: "Vintage Vinyl Shop", location: "Maple Ave", distance: 1.2, date: Date().addingTimeInterval(3600 * 12), imageName: nil, handle: "@vinylvault", businessName: "Vinyl Vault", kind: .shop)
]
#endif

// Placeholder store to make saves work
@MainActor
final class SavedListingsStore: ObservableObject {
    @Published private(set) var saved: Set<UUID> = []
    func isSaved(listing: Listing) -> Bool { saved.contains(listing.id) }
    func toggleSave(listing: Listing) {
        if saved.contains(listing.id) { saved.remove(listing.id) } else { saved.insert(listing.id) }
    }
}

// Placeholder detail page
struct ListingDetailPage: View {
    let listing: Listing
    var body: some View {
        VStack(spacing: 12) {
#if USE_FEED_PLACEHOLDERS
            Text(listing.kind.rawValue.capitalized)
#else
            // Kind not available on the app's Listing type
            EmptyView()
#endif
            Text(listing.title).font(.title).bold()
#if USE_FEED_PLACEHOLDERS
            Text(listing.location)
            Text("\(Int(listing.distance)) miles away")
#else
            EmptyView()
#endif
        }
        .padding()
        .navigationTitle(listing.title)
    }
}

// MARK: - Feed
struct FeedView: View {
    @StateObject private var savedListingsStore = SavedListingsStore()
#if USE_FEED_PLACEHOLDERS
    var listings: [Listing] = sampleListings
#else
    var listings: [Listing] = []
#endif

    var body: some View {
        VStack(spacing: 0) {
            FeedListView(listings: listings)
                .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity, alignment: Alignment.top)
        }
        .padding(.horizontal)
        .environmentObject(savedListingsStore)
    }
}

struct FeedListView: View {
    var listings: [Listing]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(listings) { listing in
                    NavigationLink(destination: ListingDetailPage(listing: listing)) {
                        FeedItemView(listing: listing)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical)
        }
        .cornerRadius(16)
        .shadow(radius: 8)
    }
}

struct FeedItemView: View {
    let listing: Listing
    @EnvironmentObject var savedListingsStore: SavedListingsStore
    @State private var likes = Int.random(in: 50...200)
    @State private var comments = Int.random(in: 0...20)
    @State private var saves = Int.random(in: 10...40)
    @State private var shares = Int.random(in: 20...100)

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Circle()
                .fill(Color.purple.opacity(0.2))
                .frame(width: 30, height: 30)
                .overlay(Text(String(listing.title.prefix(1))).foregroundColor(.black))
            VStack(alignment: .leading, spacing: 4) {
#if USE_FEED_PLACEHOLDERS
                Text(listing.location)
                Text(listing.handle ?? listing.businessName ?? "@" + listing.title.replacingOccurrences(of: " ", with: "").lowercased()).bold()
                Text("\(Int(listing.distance)) miles away! \(listing.kind.rawValue.capitalized) in \(timeUntil(listing.date))")
                    .font(.caption)
#else
                Text("@" + listing.title.replacingOccurrences(of: " ", with: "").lowercased()).bold()
                // The app's Listing doesn't expose date/distance/kind; show a generic subtitle instead
                Text("Coming up soon")
                    .font(.caption)
#endif
                HStack {
                    Button(action: { likes += 1 }) {
                        Label("\(likes)", systemImage: "heart")
                    }
                    Button(action: { comments += 1 }) {
                        Label("\(comments)", systemImage: "text.bubble")
                    }
                    Button(action: { savedListingsStore.toggleSave(listing: listing)}) {
                        Label(
                            savedListingsStore.isSaved(listing: listing) ? "Saved" : "Save",
                            systemImage: savedListingsStore.isSaved(listing: listing) ? "bookmark.fill" : "bookmark"
                        )
                    }
                    Button(action: { shares += 1 }) {
                        Label("\(shares)", systemImage: "square.and.arrow.up")
                    }
                }
                .font(.caption)
                .foregroundColor(Color("DarkGreen"))
            }
            // Show image if available, else placeholder
            if let name = Optional(listing.imageName), !name.isEmpty {
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("FontColor"), lineWidth: 2)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .padding(16)
                            .foregroundColor(Color("GreenGreen"))
                    )
            }
        }
        .padding()
        .background(Color("GreenGreen"))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
// MARK: - Helpers
func timeUntil(_ date: Date) -> String {
    let interval = Int(date.timeIntervalSinceNow)
    let hours = max(0, interval) / 3600
    let minutes = (max(0, interval) % 3600) / 60
    return "\(hours)hrs\(minutes)min"
}
// MARK: - Preview
#if DEBUG
// Enable placeholders for previews to avoid depending on app models
#Preview {
    // Define the compilation condition for this preview build configuration only
    // Add `-D USE_FEED_PLACEHOLDERS` to the preview build settings if needed.
    NavigationView {
        FeedView()
    }
}
#endif

