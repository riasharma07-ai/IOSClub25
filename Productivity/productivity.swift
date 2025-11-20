import SwiftUI
import Combine
import EventKit

// MARK: - Theme definitions
enum Theme: String, CaseIterable {
    case light, dark, ocean, sunset // default
    
    var backgroundColor: Color {
        switch self {
        case .light: return .white
        case .dark: return Color.black.opacity(0.95)
        case .ocean: return Color.blue.opacity(0.2)
        case .sunset: return Color.orange.opacity(0.3)
        }
    }
    
    var cardColor: Color {
        switch self {
        case .light: return Color.white
        case .dark: return Color.gray.opacity(0.3)
        case .ocean: return Color.cyan.opacity(0.09)
        case .sunset: return Color.yellow.opacity(0.09)
        }
    }
    
    var accentColor: Color {
        switch self {
        case .light: return .blue
        case .dark: return .yellow
        case .ocean: return .teal
        case .sunset: return .yellow
        }
    }
    
    var textColor: Color {
        switch self {
        case .light: return .black
        case .dark: return .white
        case .ocean: return .black
        case .sunset: return .black
        }
    }
    
    var iconColor: Color {
        switch self {
        case .light: return .blue
        case .dark: return .red
        case .ocean: return Color(red: 0.78, green: 0.72, blue: 0.71)
        case .sunset: return .pink
        }
    }
    
    var profilePicColor1: Color {
        switch self {
        case .light, .dark, .ocean: return .blue
        case .sunset: return .yellow
        }
    }
    
    var profilePicColor2: Color {
        switch self {
        case .light: return .blue
        case .dark: return .black
        case .ocean: return .mint
        case .sunset: return .pink
        }
    }
    
    var personalInfoTitles: Color {
        switch self {
        case .light, .ocean, .sunset: return .gray
        case .dark: return .white
        }
    }
    
    var editProfileColor: Color {
        switch self {
        case .light: return .black
        case .dark, .ocean: return .blue
        case .sunset: return .yellow
        }
    }
    
    var barsColor: Color {
        switch self {
        case .light: return .blue
        case .dark: return .red
        case .ocean: return .mint
        case .sunset: return .pink
        }
    }
}

// MARK: - Sample Data
let theHabits = [
    Habit(title: "30 minutes of cardio", isComplete: true, date: nil),
    Habit(title: "Read for 10 minutes", isComplete: false, date: nil),
    Habit(title: "Drink 8 glasses of water", isComplete: true, date: nil)
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

// MARK: - ThemeManager
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .sunset
}

// MARK: - HabitStore
class HabitStore: ObservableObject {
    @Published var habits: [Habit] = theHabits
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
}

// MARK: - Models
struct Habit: Identifiable {
    let id = UUID()
    let title: String
    var isComplete: Bool = false
    let date: Date?
}

struct Day: Identifiable {
    let id = UUID()
    let day: String
    let taskDone: Int
}

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

// MARK: - ProfileInfoRow
struct ProfileInfoRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(themeManager.currentTheme.iconColor)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(themeManager.currentTheme.personalInfoTitles)
                Text(value)
                    .font(.body)
                    .foregroundColor(themeManager.currentTheme.textColor)
            }

            Spacer()
        }
        .padding()
        .background(themeManager.currentTheme.cardColor)
        .cornerRadius(15)
    }
}

// MARK: - ContentView
struct ContentView: View {
    @StateObject var habitStore = HabitStore()
    @StateObject var themeManager = ThemeManager()
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HabitsView()
                .environmentObject(habitStore)
                .environmentObject(themeManager)
                .tag(0)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Habits")
                }
            
            DashboardView(selectedTab: $selectedTab)
                .environmentObject(habitStore)
                .environmentObject(themeManager)
                .tag(1)
                .tabItem {
                    Image(systemName: "speedometer")
                    Text("Dashboard")
                }
            
            CalendarView(selectedTab: $selectedTab)
                .environmentObject(habitStore)
                .environmentObject(themeManager)
                .tag(2)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            ProfileView()
                .environmentObject(themeManager)
                .tag(3)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .accentColor(themeManager.currentTheme.accentColor)
        .background(themeManager.currentTheme.backgroundColor)
    }
}

// MARK: - HabitsView
struct HabitsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Habits in progress:")
                    .font(.title2)
                    .padding()
                
                VStack {
                    ForEach(habitStore.habits, id: \.title) { habit in
                        Text(habit.title)
                            .padding()
                            .background(habit.isComplete ? Color.green.opacity(0.5) : Color.gray.opacity(0.5))
                            .foregroundColor(themeManager.currentTheme.textColor)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
            .navigationTitle("Habits")
        }
    }
}

// MARK: - DashboardView
struct DashboardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    let messages = [
        "Hello! Ready to tackle the day? ☀️💪",
        "You're doing great, keep going! 🌟🔥",
        "So proud of you, keep it up. 😊👏"
    ]
    
    var totalHabits: Int { theHabits.count }
    var completedHabits: Int { theHabits.filter { $0.isComplete }.count }
    private var streak = 12
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text(messages.randomElement() ?? "")
                        .font(.title3)
                        .italic()
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    VStack {
                        Text("TODAY")
                            .font(.title2)
                            .bold()
                        Spacer().frame(height: 6)
                        HStack {
                            Text("Completed:").bold()
                            Text("\(completedHabits)/\(totalHabits) tasks")
                        }
                        Spacer().frame(height: 6)
                        HStack {
                            Text("Streak:").bold()
                            Text("\(streak) 🔥")
                        }
                    }
                    .padding()
                    .background(themeManager.currentTheme.cardColor)
                    .cornerRadius(12)
                    
                    Text("Weekly Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(alignment: .bottom, spacing: 12) {
                        ForEach(weekData) { day in
                            VStack(spacing: 6) {
                                Rectangle()
                                    .fill(themeManager.currentTheme.barsColor.opacity(0.6))
                                    .frame(width: 20, height: CGFloat(day.taskDone) / 5.0 * 120)
                                Text(day.day)
                                    .font(.caption2)
                            }
                        }
                    }
                    
                    let averageTasks: Double = {
                        let total = weekData.reduce(0) { $0 + $1.taskDone }
                        return Double(total) / Double(weekData.count)
                    }()
                    
                    Text("Based on your history,")
                        .italic()
                    Text("try setting a goal for \(Int(averageTasks)) tasks per day.")
                        .italic()
                    
                    Divider().padding(.vertical, 8)
                    
                    Text("Today’s Top 3").font(.headline)
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(theHabits, id: \.title) { habit in
                            Text(habit.title)
                                .padding()
                                .background(habit.isComplete ? Color.green.opacity(0.5) : Color.gray.opacity(0.5))
                                .cornerRadius(8)
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button("Add New Habit") { selectedTab = 0 }
                            .buttonStyle(DefaultButtonStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(themeManager.currentTheme.accentColor.opacity(0.2))
                            .cornerRadius(8)
                        
                        Button("View Full Calendar") { selectedTab = 2 }
                            .buttonStyle(BorderlessButtonStyle())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.clear)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
            .navigationTitle("Dashboard")
        }
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var habitStore: HabitStore
    @Binding var selectedTab: Int
    
    @State private var selectedDate = Date()
    @State private var showHabitInput = false
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding()
                    .tint(themeManager.currentTheme.accentColor)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Habits for this day:")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.textColor)
                    
                    ForEach(habitStore.habits.filter { habit in
                        guard let habitDate = habit.date else { return false }
                        return Calendar.current.isDate(habitDate, inSameDayAs: selectedDate)
                    }) { habit in
                        Text(habit.title)
                            .padding(6)
                            .background(themeManager.currentTheme.cardColor)
                            .cornerRadius(6)
                            .foregroundColor(themeManager.currentTheme.textColor)
                    }
                    
                    if habitStore.habits.filter({ habit in
                        guard let habitDate = habit.date else { return false }
                        return Calendar.current.isDate(habitDate, inSameDayAs: selectedDate)
                    }).isEmpty {
                        Text("No habits for this day.")
                            .italic()
                            .foregroundColor(themeManager.currentTheme.textColor.opacity(0.7))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("Add Habit") { showHabitInput = true }
                    .buttonStyle(.borderedProminent)
                    .tint(themeManager.currentTheme.accentColor)
                    .padding()
            }
            .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
            .sheet(isPresented: $showHabitInput) {
                HabitInputView()
                    .environmentObject(themeManager)
                    .environmentObject(habitStore)
            }
        }
    }
}

// MARK: - HabitInputView
struct HabitInputView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var habitStore: HabitStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitTitle: String = ""
    @State private var selectedDate: Date = Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Habit Title", text: $habitTitle)
                .padding()
                .background(themeManager.currentTheme.cardColor)
                .cornerRadius(10)
                .foregroundColor(themeManager.currentTheme.textColor)
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .padding()
                .tint(themeManager.currentTheme.accentColor)
            
            Button("Save Habit") {
                saveHabit()
            }
            .padding()
            .background(themeManager.currentTheme.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Habit"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                dismiss()
            })
        }
    }
    
    private func saveHabit() {
        guard !habitTitle.isEmpty else {
            alertMessage = "Please enter a habit title."
            showAlert = true
            return
        }
        
        let newHabit = Habit(title: habitTitle, isComplete: false, date: selectedDate)
        habitStore.addHabit(newHabit)
        
        addHabitToCalendar(title: habitTitle, date: selectedDate)
        
        alertMessage = "Habit saved successfully!"
        showAlert = true
    }
    
    private func addHabitToCalendar(title: String, date: Date) {
        let eventStore = EKEventStore()
        
        let saveEvent: () -> Void = {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = date
            event.endDate = date.addingTimeInterval(60 * 60)
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
                print("Habit saved to Calendar!")
            } catch {
                print("Failed to save event: \(error.localizedDescription)")
            }
        }
        
        if #available(iOS 17.0, *) {
            eventStore.requestWriteOnlyAccessToEvents { granted, error in
                if granted && error == nil { saveEvent() }
                else { print("Calendar access denied or error: \(error?.localizedDescription ?? "unknown")") }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                if granted && error == nil { saveEvent() }
                else { print("Calendar access denied or error: \(error?.localizedDescription ?? "unknown")") }
            }
        }
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @EnvironmentObject var themeManager: ThemeManager
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
    
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    // Profile Picture
                    ZStack {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [themeManager.currentTheme.profilePicColor1, themeManager.currentTheme.profilePicColor2]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 100, height: 100)

                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)

                    VStack(spacing: 5) {
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.currentTheme.textColor)
                        Text("Joined: \(user.joinDate)")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }

                    VStack(spacing: 0) {
                        Text("Bio")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        VStack(spacing: 0) {
                            ProfileInfoRow(icon: "person.fill", title: "About", value: user.bio)
                            ProfileInfoRow(icon: "bubble.right.fill", title: "Quote", value: user.quote)
                        }
                        .background(themeManager.currentTheme.cardColor)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)

                        Text("Personal Information")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        VStack(spacing: 0) {
                            ProfileInfoRow(icon: "person.fill", title: "Username", value: user.userName)
                            ProfileInfoRow(icon: "envelope.fill", title: "Email", value: user.email)
                            ProfileInfoRow(icon: "phone.fill", title: "Phone", value: user.phoneNumber)
                            ProfileInfoRow(icon: "calendar", title: "Birthday", value: user.bday)
                        }
                        .background(themeManager.currentTheme.cardColor)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Profile")
            .navigationBarItems(trailing:
                                    Button("Edit Profile") { showingEditProfile = true }
                                        .foregroundColor(themeManager.currentTheme.editProfileColor)
            )
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: $user)
                    .environmentObject(themeManager)
            }
            .background(themeManager.currentTheme.backgroundColor.ignoresSafeArea())
        }
    }
}

// MARK: - EditProfileView
struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var user: UserProfile

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
                    TextField("Bio", text: $editedBio)
                    TextField("Quote", text: $editedQuote)
                    TextField("Email", text: $editedEmail)
                        .keyboardType(.emailAddress)
                    TextField("Phone", text: $editedPhone)
                        .keyboardType(.phonePad)
                    TextField("Birthday", text: $editedBday)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") {
                    user.name = editedName
                    user.bio = editedBio
                    user.quote = editedQuote
                    user.email = editedEmail
                    user.phoneNumber = editedPhone
                    user.bday = editedBday
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.yellow)
            )
            .onAppear {
                editedName = user.name
                editedBio = user.bio
                editedQuote = user.quote
                editedEmail = user.email
                editedPhone = user.phoneNumber
                editedBday = user.bday
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
