import SwiftUI

enum Tab {
    case feed, search, saved, trips, chat, profile
}

struct NavigationBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            NavTabButton(icon: "house", label: "Feed", isSelected: selectedTab == .profile) {
                selectedTab = .feed
            }
            NavTabButton(icon: "magnifyingglass", label: "Search", isSelected: selectedTab == .search) {
                selectedTab = .search
            }
            NavTabButton(icon: "pencil.and.outline", label: "Trips", isSelected: selectedTab == .trips) {
                selectedTab = .trips
            }
            NavTabButton(icon: "heart", label: "Saved", isSelected: selectedTab == .saved) {
                selectedTab = .saved
            }
            NavTabButton(icon: "person", label: "Profile", isSelected: selectedTab == .profile) {
                selectedTab = .profile
            }
        }
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .background(
            Image("noise")
                .resizable()
                .scaledToFill()
                .opacity(0.03)
        )
    }
    
    struct NavTabButton: View {
        let icon: String
        let label: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack {
                    Image(systemName: icon)
                        .font(.system(size: 32, weight: .regular))
                        .foregroundColor(Color("FontColor"))
                    Text(label)
                        .font(.caption)
                        .foregroundColor(Color("FontColor"))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
   
