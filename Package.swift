// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import SwiftUI

struct AppIcon: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let systemImage: String
}

struct HomeScreenView: View {
    // Example app data
    let apps = [
        AppIcon(name: "Mail", color: .blue, systemImage: "envelope.fill"),
        AppIcon(name: "Calendar", color: .red, systemImage: "calendar"),
        AppIcon(name: "Photos", color: .yellow, systemImage: "photo.fill"),
        AppIcon(name: "Camera", color: .gray, systemImage: "camera.fill"),
        AppIcon(name: "Maps", color: .green, systemImage: "map.fill"),
        AppIcon(name: "Music", color: .pink, systemImage: "music.note"),
        AppIcon(name: "App Store", color: .blue, systemImage: "bag.fill"),
        AppIcon(name: "Settings", color: .gray, systemImage: "gearshape.fill"),
        AppIcon(name: "Clock", color: .black, systemImage: "clock.fill"),
        AppIcon(name: "Weather", color: .cyan, systemImage: "cloud.sun.fill"),
        AppIcon(name: "Notes", color: .yellow, systemImage: "note.text"),
        AppIcon(name: "Reminders", color: .white, systemImage: "checklist")
    ]

    var body: some View {
        ZStack {
            // Wallpaper background
            LinearGradient(
                colors: [.blue.opacity(0.8), .purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Time and Status Bar (mock)
                Text("9:41")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.top, 40)

                Spacer().frame(height: 10)

                // Apps grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 25) {
                    ForEach(apps) { app in
                        VStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(app.color)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: app.systemImage)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 25))
                                )

                            Text(app.name)
                                .font(.caption)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)

                Spacer()

                // Dock
                ZStack {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(.ultraThinMaterial)
                        .frame(height: 100)
                        .padding(.horizontal, 20)

                    HStack(spacing: 40) {
                        dockIcon("phone.fill", color: .green)
                        dockIcon("message.fill", color: .blue)
                        dockIcon("safari.fill", color: .blue)
                        dockIcon("music.note", color: .pink)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }

    func dockIcon(_ systemImage: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(color)
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: systemImage)
                    .foregroundStyle(.white)
                    .font(.system(size: 25))
            )
    }
}

#Preview {
    HomeScreenView()
}
