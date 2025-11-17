import SwiftUI

// Main app view with tab navigation
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

// Ria S!

// Temporary struct till Habits tab is created
struct Habit{
    let title: String
    let isComplete: Bool
}

struct Day: Identifiable {
    let id = UUID()
    let day: String
    let taskDone: Int
}

struct DashboardView: View {
    
    // Daily messages that keep alternating
    let messages = [
        "Hello! Ready to tackle the day? ☀️💪", "You're doing great, keep going! 🌟🔥", "So proud of you, keep it up 😊👏", "Even small progress counts. 🌱✨", "One step at a time — you’ve got this! 🧗‍♀️💛", "A little progress every day adds up. 📈✨", "You're amazing, keep shining! 🌈💖", "Show up for yourself today 🤍💪", "Do it for the future you 💫🫶", "Small habits, big results! 🌱➡️🌳", "Discipline > motivation. You’re doing amazing! ⚡️💪"
    ]
    // Mock Data for now until Habits/Calendar tabs are created (uses structs above)
    
    let todaysHabits = [
        Habit(title: "30 minutes of cardio", isComplete: true),
        Habit(title: "Read for 10 minutes", isComplete: false),
        Habit(title: "Drink 8 glasses of water", isComplete: true)
    ]
    
    let weekData = [
        Day(day: "Sun", taskDone: 5),
        Day(day: "Mon", taskDone: 4),
        Day(day: "Tue", taskDone: 4),
        Day(day: "Wed", taskDone: 2),
        Day(day: "Thu", taskDone: 3),
        Day(day: "Fri", taskDone: 2),
        Day(day: "Sat", taskDone: 1)
    ]
    var totalHabits: Int {
        todaysHabits.count
    }
    var completedHabits: Int {
        todaysHabits.filter { $0.isComplete }.count
    }
    private var streak = 12
    
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    Text(messages.randomElement()!)
                        .font(.headline)
                        .italic()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    VStack{
                        Text("TODAY:")
                            .fixedSize()
                            .bold()
                        Spacer()
                        HStack{
                            Text("Completed:")
                                .bold()
                            Text("\(completedHabits)/\(totalHabits) tasks")
                        }
                        Spacer()
                        HStack{
                            Text("Streak:")
                                .bold()
                            Text("\(streak) 🔥")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.mint.opacity(0.2))
                            .frame(width: 300, height: 110)
                    )
                    // Weekly Overview (Bar Graph with struct as placeholder)
                    Spacer()
                        .frame(height: 10)
                    Text("Weekly Overview").font(.headline)
                        VStack{
                            // Y-Axis
                            HStack(alignment: .bottom, spacing: 0){
                                VStack{
                                    ForEach((0...5).reversed(), id: \.self) { label in
                                        Spacer()
                                        Text("\(label)")
                                            .font(.caption2)
                                            .frame(height: 20)
                                    }
                                }
                                .frame(width: 20)
                                
                                // Bars and X-Axis
                                GeometryReader { geo in
                                    HStack(alignment: .bottom, spacing: 16) {
                                        ForEach(weekData) { day in
                                            VStack (spacing: 4){
                                                Spacer()
                                                    .frame(height: 15)
                                                // Bar
                                                Rectangle()
                                                    .fill(Color.blue)
                                                    .frame(
                                                        width: 20,
                                                        height: CGFloat(day.taskDone) / CGFloat(5) * 140 )
                                                
                                                // X-axis label
                                                Text(day.day)
                                                    .font(.caption2)
                                                    .frame(height: 14)
                                            }
                                        }
                                    }
                                    .frame(width: geo.size.width, alignment: .center)
                                }
                                .frame(width: CGFloat(weekData.count) * 36)
                            }
                        }
                            .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                        .frame(height: 20)
                    var averageTasks: Double {
                        let total = weekData.reduce(0) {$0 + $1.taskDone}
                        return Double(total) / Double(weekData.count)
                    }
                    Text("Try setting a goal for \(Int(averageTasks)) tasks per day.")
                        .italic()
                                    
                                    Divider()
                                    Spacer()
                                    
                                    // Quick Actions
                                    Text("Today’s Top 3").font(.headline)
                                        VStack(alignment: .leading, spacing: 10) {
                                            ForEach(todaysHabits, id: \.title) { habit in
                                                Text(habit.title)
                                                    .padding()
                                                    .background(habit.isComplete ? Color.green.opacity(0.5) : Color.gray.opacity(0.5))
                                                    .cornerRadius(8)
                                            }
                                        }
                                    HStack {
                                        Button("Add New Habit") { print("Add tapped") }
                                            .buttonStyle(.borderedProminent)
                                        Button("View Full Calendar") { print("Calendar tapped") }
                                            .buttonStyle(.bordered)
                                    }
                }
                .navigationTitle("Dashboard")
            }
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

// Ria S!
struct ProfileView: View {
    private var user = UserProfile(
        name: "Random User",
        email: "random.user@gmail.com",
        phoneNumber: "+1 123 456 7890",
        joinDate: "November 2025"
    )
    
    @State private var notificationsEnabled = false
    @State private var showEditProfile = false
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

struct UserProfile {
    var name: String
    var email: String
    var phoneNumber: String
    let joinDate: String
}
