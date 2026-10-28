//
//  HomeView.swift
//  TatBook
//
//  Created by Aubri McEachern on 12/15/25.
//

import Foundation
import SwiftUI
internal import Combine

final class WishlistManager: ObservableObject {
    @Published private(set) var savedListingIDs: Set<UUID> = []

    func add(_ id: UUID) { savedListingIDs.insert(id) }
    func remove(_ id: UUID) { savedListingIDs.remove(id) }
    func isSaved(_ id: UUID) -> Bool { savedListingIDs.contains(id) }
}

// MARK: - Tab Model


enum HomeMode: String, CaseIterable {
    case shops = "Shops"
    case workshops = "Workshops"
    case conventions = "Conventions"
}

struct HomeView: View {
    @State private var selectedMode: HomeMode = .shops
    @State private var selectedTab: Tab = .search
    @StateObject private var wishlist = WishlistManager()

    var body: some View {
        VStack(spacing: 0) {
            tabContent
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider()
                NavigationBar(selectedTab: $selectedTab)
            }
            .background(.ultraThinMaterial)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("GreenGreen"), Color.white.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
        )
        .environmentObject(wishlist)
    }


        @ViewBuilder
        var tabContent: some View {
            switch selectedTab {
            case .search:
                VStack(spacing: 0) {
                    TopBar(onPlus: {}, onChat: {})
                    // --- homeview content
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .padding(.leading)
                        }
                        TextField("Start your search", text: .constant(""))
                            .padding(10)
                               .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                               .overlay(
                                   RoundedRectangle(cornerRadius: 20, style: .continuous)
                                       .stroke(Color.white.opacity(0.15), lineWidth: 1)
                               )
                               .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing)
                    }
                    .padding(.top, 10)
                    

                    
                    HStack(spacing: 0) {
                        ForEach(HomeMode.allCases, id: \.self) { mode in
                            Button(action: { selectedMode = mode }) {
                                Text(mode.rawValue)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedMode == mode ? .black : .gray)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedMode == mode
                                        ? Color.white
                                        : Color.clear
                                    )
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .background(.ultraThinMaterial)
                    .background(Color("GreenGreen"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("View details of your Paris trip")
                                .font(.headline)
                            Text("May 22 – 26 · 3 guests")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        VStack {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                            Text("STARTS IN\n7 DAYS")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(sectionTitles(for: selectedMode), id: \.self) { section in
                                VStack(alignment: .leading) {
                                    Text(section)
                                        .font(.headline)
                                        .padding(.horizontal)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(sampleListings(for: selectedMode), id: \.id) { listing in
                                                HomeListingCard(listing: listing)
                                                    .environmentObject(wishlist)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            case .feed:
                FeedView()
            case .saved:
                SavedListingsView()
            case .trips:
                TripsView()
            case .chat:
                ChatView()
            case .profile:
                ProfileView()
            }
        }
    }


// MARK: - Helper Views & Data

struct TabBarButton: View {
    let icon: String
    let label: String
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(label)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        // Color is provided by parent (NavigationBar)
    }
}

struct HomeListing: Identifiable {
    let id = UUID()
    let title: String
    let price: String
    let imageName: String
    let tag: String
}

struct HomeListingCard: View {
    let listing: HomeListing
    @EnvironmentObject var wishlist: WishlistManager
    @State private var showWishlistSheet = false
    private let cardWidth: CGFloat = 160
    private let imageCornerRadius: CGFloat = 12
    private let imageHeight: CGFloat = 140

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(listing.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: imageHeight)
                    .clipped()
                    .cornerRadius(imageCornerRadius)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 2)
                Button(action: {
                    showWishlistSheet = true
                }) {
                    Image(systemName: wishlist.isSaved(listing.id) ? "heart.fill" : "heart")
                        .foregroundColor(wishlist.isSaved(listing.id) ? Color("lightPink") : .primary)
                        .padding(6)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                }
                .padding(6)
                .sheet(isPresented: $showWishlistSheet) {
                    WishlistSelectionView(onSelect: {
                        wishlist.add(listing.id)
                        // Keep the sheet open so user can add more if desired.
                        // To auto-close, uncomment the next line.
                        // showWishlistSheet = false
                    })
                }
            }
            Text(listing.tag)
                .font(.caption2)
                .padding(4)
                .background(Color.white.opacity(0.8))
                .cornerRadius(6)
            Text(listing.title)
                .font(.subheadline)
                .lineLimit(2)
            Text(listing.price)
                .font(.headline)
                .bold()
        }
        .frame(width: cardWidth) // <-- THIS IS CRUCIAL
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
    }
}


 // MARK: - Sample Data & Section Titles

func sectionTitles(for mode: HomeMode) -> [String] {
    switch mode {
    case .shops:
        return ["Popular Shops in France", "Popular Shops in Paris"]
    case .workshops:
        return ["Popular Workshops in France", "Popular Workshops in Paris"]
    case .conventions:
        return ["Upcoming Conventions in France", "Upcoming Conventions in Paris"]
    }
}

func sampleListings(for mode: HomeMode) -> [HomeListing] {
    switch mode {
    case .shops:
        return [
            HomeListing(title: "Hellfire Tattoo Co.", price: "$150/day", imageName: "tattooer3", tag: "Original"),
            HomeListing(title: "All Saints Tattoo Shop", price: "$150/day", imageName: "tattooer10", tag: "Original"),
            HomeListing(title: "Notre Dame Tattoo Co.", price: "$1000/month", imageName: "tattooer6", tag: "Original"),
            HomeListing(title: "String of Pearls Tattoo", price: "$400/week", imageName: "tattooer11", tag: "Original")
        ]
    case .workshops:
        return [
            HomeListing(title: "Realism Fundamentals with @bigtraddydaddy", price: "$1000/day", imageName: "tattooer4", tag: "Original"),
            HomeListing(title: "NeoTrad Bootcamp with @leoslime", price: "$5000/week", imageName: "tattooer9", tag: "Original"),
            HomeListing(title: "Traditional Tattoo History with @tattertot", price: "$150/3 hours", imageName: "tattooer3", tag: "Original"),
            HomeListing(title: "Tattoo Ethics with @pattymelttats", price: "Free", imageName: "tattooer10", tag: "Original"),
        ]
    case .conventions:
        return [
            HomeListing(title: "Notre Dame Tattoo Fest", price: "$1000/booth", imageName: "tattooer6", tag: "Original"),
            HomeListing(title: "20th Annual Paris Tattoo Festival", price: "$480/booth", imageName: "tattooer11", tag: "Original"),
            HomeListing(title: "Big Baby Tattoo Festival", price: "$500/booth", imageName: "tattooer9", tag: "Original"),
            HomeListing(title: "Sweet Tooth Tattoo Expo", price: "$450/booth", imageName: "tattooer3", tag: "Original"),
            
        ]
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

