import SwiftUI

// Main app view with tab navigation
struct ContentView: View {
    @State private var selectedTab = 1 // starting UI on Dashboard
    var body: some View {
        TabView (selection: $selectedTab){
            HabitsView()
                .tag(0)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Habits")
                }
            
            DashboardView(selectedTab: $selectedTab)
                .tag(1)
                .tabItem {
                    Image(systemName: "speedometer")
                    Text("Dashboard")
                }
            
            CalendarView(selectedTab: $selectedTab)
                .tag(2)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            ProfileView()
                .tag(3)
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

// Dashboard - Ria Sh

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
    @Binding var selectedTab: Int
    // Daily messages that keep alternating
    
    init(selectedTab: Binding<Int>) {
            self._selectedTab = selectedTab
        }
    
    let messages = [
        "Hello! Ready to tackle the day? ☀️💪", "You're doing great, keep going! 🌟🔥", "So proud of you, keep it up 😊👏", "Even small progress counts. 🌱", "One step at a time, you’ve got this! 🧗‍♀️", "A little progress every day adds up. 📈✨", "You're amazing, keep shining! 🌈💖", "Show up for yourself today 🤍", "Do it for the future you. 💫🫶", "Small habits, big results! 🌱➡️🌳", "Discipline > motivation. ⚡️💪"
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
                        .font(.title3)
                        .italic()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    VStack{
                        Text("TODAY")
                            .font(.title2)
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
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.4), radius: 12, x:0, y:2)
                    // Weekly Overview (Bar Graph with struct as placeholder)
                    Spacer()
                        .frame(height: 10)
                    Text("Weekly Overview").font(.title2).fontWeight(.bold)
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
                                                .fill(Color.orange.opacity(0.6))
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
                    Text("Based on your history,")
                        .italic()
                    Text("try setting a goal for \(Int(averageTasks)) tasks per day.")
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
                    Spacer()
                    HStack {
                        Button("Add New Habit") {
                            print("Add tapped")
                            selectedTab = 0
                        }
                        .buttonStyle(.borderedProminent)
                        Button("View Full Calendar") {
                            print("Calendar tapped")
                            selectedTab = 2
                        }
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
    @Binding var selectedTab: Int
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


// Profile Tab - Ria S
struct ProfileView: View {
    @State private var user = UserProfile(
        name: "Random Subject",
        email: "random.user@gmail.com",
        phoneNumber: "+1 123 456 7890",
        joinDate: "November 2025",
        userName: "@random_sub",
        bday: "1/1/2005",
        bio: "Hello! I'm a new user and I'm excited to join the community!",
        quote: "Be the change you want to see."
    )
    
    @State private var notificationsEnabled = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                VStack(spacing: 15) {
                    // Profile Picture
                    ZStack{
                        Circle()
                            .fill(LinearGradient (
                                gradient: Gradient(colors: [.yellow, .pink]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)
                        
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    // Name and Join Date
                    VStack(spacing: 5){
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Joined: " + user.joinDate)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    
                    
                    // Personal Info Display
                    VStack(spacing: 0){
                        Text("Bio")
                            .frame(maxWidth: 360, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(spacing: 0){
                            ProfileInfoRow(icon: "person.fill", title: "About", value: user.bio)
                            ProfileInfoRow(icon: "bubble.right.fill", title: "Quote", value: user.quote)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        Spacer()
                        Text("Personal Information")
                            .frame(maxWidth: 360, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(spacing: 0){
                            ProfileInfoRow(icon: "person.fill", title: "Username", value: user.userName)
                            ProfileInfoRow(icon: "envelope.fill", title: "Email", value: user.email)
                            ProfileInfoRow(icon: "phone.fill", title: "Phone", value: user.phoneNumber)
                            ProfileInfoRow(icon: "calendar", title: "Birthday", value: user.bday)
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Edit Profile"){
                        showingEditProfile = true
                    }
                    .foregroundColor(.yellow)
                }
            }
        }
        
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(user: $user)
        }
        
    }
    
    
    // Editing Profile Info
    struct EditProfileView: View {
        @Binding var user: UserProfile
        @Environment(\.presentationMode) var presentationMode
        
        @State private var editedName: String = ""
        @State private var editedEmail: String = ""
        @State private var editedPhone: String = ""
        @State private var editedBday: String = ""
        @State private var editedBio: String = ""
        @State private var editedQuote: String = ""
        
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Full Name", text: $editedName)
                        TextField("Tell us a little about yourself!", text: $editedBio)
                        TextField("What's one of your favorite motivational quotes?", text: $editedQuote)
                        TextField("Email", text: $editedEmail)
                            .keyboardType(.emailAddress)
                        TextField("Phone", text: $editedPhone)
                            .keyboardType(.phonePad)
                        TextField("Birthday", text: $editedBday)
                    }
                }
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            user.bio = editedBio
                            user.quote = editedQuote
                            user.name = editedName
                            user.email = editedEmail
                            user.phoneNumber = editedPhone
                            user.bday = editedBday
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.yellow)
                    }
                }
            }
            .onAppear {
                editedBio = user.bio
                editedQuote = user.quote
                editedName = user.name
                editedEmail = user.email
                editedPhone = user.phoneNumber
                editedBday = user.bday
            }
        }
    }
    
    // User Data
    struct UserProfile {
        var name: String
        var email: String
        var phoneNumber: String
        let joinDate: String
        var userName: String
        var bday: String
        var bio: String
        var quote: String
        
        var initials: String {
            let components = name.components(separatedBy: " ")
            let firstInitial = components.first?.first?.uppercased() ?? ""
            let lastInitial = components.count > 1 ? components.last?.first?.uppercased() ?? "" : ""
            return firstInitial + lastInitial
        }
    }
    
    // Structure for a row of personal info
    struct ProfileInfoRow: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.yellow)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
}
