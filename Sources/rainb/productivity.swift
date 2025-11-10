import SwiftUI

// main app view with tab navigation
struct ContentView: View {
    var body: some View {
        TabView {
            HabitsView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Habits")
                }
            
            DashboardView()
                .tabItem {
                    Image(systemName: "speedometer")
                    Text("Dashboard")
                }
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

// individual views for each tab

// Erza!
struct HabitsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Habits")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Habits")
        }
    }
}

// Ria!
struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Dashboard")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Dashboard")
        }
    }
}

// Nancy!
struct CalendarView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Calendar")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Calendar")
        }
    }
}

// Ria!
struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .padding()
                Spacer()
            }
            .navigationTitle("Profile")
        }
    }
}