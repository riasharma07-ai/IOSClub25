import SwiftUI
internal import Combine

// Theme definitions
enum Theme: String, CaseIterable {
    case light
    case dark
    case ocean
    case sunset   // default
    
    // Background Color
    var backgroundColor: Color {
        switch self {
        case .light: return .white
        case .dark: return Color.black.opacity(0.95)
        case .ocean: return Color.blue.opacity(0.2)
        case .sunset: return Color.orange.opacity(0.3)
        }
    }
    
    // Card Color
    var cardColor: Color {
        switch self {
        case .light: return Color.white
        case .dark: return Color.gray.opacity(0.3)
        case .ocean: return Color.cyan.opacity(0.09)
        case .sunset: return Color.yellow.opacity(0.09)
        }
    }
    
    // Accent (of buttons)
    var accentColor: Color {
        switch self {
        case .light: return .blue
        case .dark: return .yellow
        case .ocean: return .teal
        case .sunset: return .yellow
        }
    }
    
    // Text Color
    var textColor: Color {
        switch self {
        case .light: return .black
        case .dark: return .white
        case .ocean: return .black
        case .sunset: return .black
        }
    }
    
    // Color of Icons on Profile Page
    var iconColor: Color {
        switch self {
        case .light: return .blue
        case .dark: return .red
        case .ocean: return Color(red: 0.78, green: 0.72, blue: 0.71)
        case .sunset: return .pink
        }
    }
    
    // Color of Profile Pic (first color of gradient)
    var profilePicColor1: Color {
        switch self {
        case .light: return .blue
        case .dark: return .blue
        case .ocean: return .blue
        case .sunset: return .yellow
        }
    }
    
    // Color of Profile Pic (second color of gradient)
    var profilePicColor2: Color {
        switch self {
        case .light: return .blue
        case .dark: return .black
        case .ocean: return .mint
        case .sunset: return .pink
        }
    }
    
    // Color for the titles of personal info
    var personalInfoTitles: Color {
        switch self {
        case .light: return .gray
        case .dark: return .white
        case .ocean: return .gray
        case .sunset: return .gray
        }
    }
    
    // "Edit Profile" button color
    var editProfileColor: Color {
        switch self {
        case .light: return .black
        case .dark: return .blue
        case .ocean: return .blue
        case .sunset: return .yellow
        }
    }
    
    // Color of Bar Graph
    var barsColor: Color {
        switch self {
        case .light: return.blue
        case .dark: return .red
        case .ocean: return .mint
        case .sunset: return .pink
        }
    }
}

let theHabits = [
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

// MARK: - Theme manager (shared)
class ThemeManager: ObservableObject {
    @Published var currentTheme: Theme = .sunset
}
// MARK: - ContentView (TabView)
struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
        // Tab accent color follows theme
        .accentColor(themeManager.currentTheme.accentColor)
        .background(themeManager.currentTheme.backgroundColor)
    }
}

// MARK: - HabitsView
struct HabitsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Habits in progress:")
                    .font(.title2)
                    .padding()
                VStack {
                    ForEach(theHabits, id: \.title) { habit in
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
            .background(themeManager.currentTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .foregroundColor(themeManager.currentTheme.textColor)
            .navigationTitle("Habits")
            .navigationBarTextColor(themeManager.currentTheme == .dark ? .white : .black)
        }
    }
}

struct Habit {
    let title: String
    let isComplete: Bool
}

struct Day: Identifiable {
    let id = UUID()
    let day: String
    let taskDone: Int
}

// DashboardView
struct DashboardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    let messages = [
        "Hello! Ready to tackle the day? ☀️💪", "You're doing great, keep going! 🌟🔥", "So proud of you, keep it up. 😊👏", "Even small progress counts. 🌱", "One step at a time, you’ve got this! 🧗‍♀️", "A little progress every day adds up. 📈", "You're amazing, keep shining! 🌈💖", "Show up for yourself today. 🤍", "Do it for the future you. 💫🫶", "Small habits, big results! 🌱➡️🌳", "Discipline > motivation. ⚡️💪"
    ]
    
    
    var totalHabits: Int { theHabits.count }
    var completedHabits: Int { theHabits.filter { $0.isComplete }.count }
    private var streak = 12
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Message
                    Text(messages.randomElement() ?? "")
                        .font(.title3)
                        .italic()
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    
                    // Today Card
                    VStack {
                        Text("TODAY")
                            .font(.title2)
                            .bold()
                        Spacer().frame(height: 6)
                        HStack {
                            Text("Completed:")
                                .bold()
                            Text("\(completedHabits)/\(totalHabits) tasks")
                        }
                        Spacer().frame(height: 6)
                        HStack {
                            Text("Streak:")
                                .bold()
                            Text("\(streak) 🔥")
                        }
                    }
                    .padding()
                    .background(themeManager.currentTheme.cardColor)
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.4), radius: 12, x: 0, y: 2)
                    
                    // Weekly Overview title
                    Text("Weekly Overview")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Weekly chart (simple)
                    HStack(alignment: .bottom, spacing: 12) {
                        ForEach(weekData) { day in
                            VStack(spacing: 6) {
                                Rectangle()
                                    .fill((themeManager.currentTheme.barsColor).opacity(0.6))
                                    .frame(width: 20, height: CGFloat(day.taskDone) / 5.0 * 120)
                                Text(day.day)
                                    .font(.caption2)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
                    
                    // Average suggestion
                    let averageTasks: Double = {
                        let total = weekData.reduce(0) { $0 + $1.taskDone }
                        return Double(total) / Double(weekData.count)
                    }()
                    
                    Text("Based on your history,")
                        .italic()
                    Text("try setting a goal for \(Int(averageTasks)) tasks per day.")
                        .italic()
                    
                    Divider().padding(.vertical, 8)
                    
                    // Quick Actions and Top 3
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
                        Button("Add New Habit") {
                            selectedTab = 0
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(themeManager.currentTheme.accentColor.opacity(0.2))
                        .cornerRadius(8)
                        
                        Button("View Full Calendar") {
                            selectedTab = 2
                        }
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
                .frame(maxWidth: .infinity)
            }
            .background(themeManager.currentTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .foregroundColor(themeManager.currentTheme.textColor)
            .navigationTitle("Dashboard")
            .navigationBarTextColor(themeManager.currentTheme == .dark ? .white : .black)
            
        }
    }
}

// CalendarView
struct CalendarView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    var onDateSelected: (Date) -> Void = { _ in }
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .tint(themeManager.currentTheme.accentColor) // theme-aware accent
                .colorScheme(themeManager.currentTheme == .dark ? .dark : .light)
                .padding()
                
                Spacer()
                
                Button("Confirm Date") {
                    onDateSelected(selectedDate)
                }
                .buttonStyle(.borderedProminent)
                .tint(themeManager.currentTheme.accentColor)
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeManager.currentTheme.backgroundColor) // theme-aware background
            .foregroundColor(themeManager.currentTheme.textColor) // theme-aware text
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTextColor(themeManager.currentTheme == .dark ? .white : .black)
        }
    }
}




// with help of a tutorial to implement a basic calendar feature

struct ScheduleView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedSessionDate: Date = Date.now
    @State private var selectedSessionHour: Date = Date.now
    
    var onDateSelected: (Date) -> Void = { _ in }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Schedule View")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(themeManager.currentTheme.textColor)
                .textCase(.uppercase)
            
            CalendarView(selectedTab: .constant(2)) { mergedDate in
                self.selectedSessionDate = mergedDate
                onDateSelected(mergedDate)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Spacer()
                Button {
                    let merged = merge(selectedSessionDate, selectedSessionHour)
                    onDateSelected(merged)
                } label: {
                    Image(systemName: "checkmark")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(themeManager.currentTheme.accentColor)
                        .padding()
                        .background(
                            Circle()
                                .fill(themeManager.currentTheme.accentColor.opacity(0.1))
                                .overlay(
                                    Circle().stroke(themeManager.currentTheme.accentColor, lineWidth: 2)
                                )
                        )
                }
            }
            .padding()
        }
        .background(themeManager.currentTheme.backgroundColor.edgesIgnoringSafeArea(.all))
        .foregroundColor(themeManager.currentTheme.textColor)
    }
}




func merge(_ date: Date, _ time: Date) -> Date {
    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
    let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
    
    
    
    var merged = DateComponents()
    
    merged.year = dateComponents.year
    
    merged.month = dateComponents.month
    
    merged.day = dateComponents.day
    
    merged.hour = timeComponents.hour
    
    merged.minute = timeComponents.minute
    
    
    
    return calendar.date(from: merged) ?? date
    
}

extension Date {
    
    static let firstDayOfWeek = Calendar.current.firstWeekday
    
    
    static var capitalizedFirstLettersOfWeekdays: [String] {
        
        let calendar = Calendar.current
        
        // Adjusted for the different weekday starts
        
        var weekdays = calendar.shortWeekdaySymbols
        
        if firstDayOfWeek > 1 {
            
            for _ in 1..<firstDayOfWeek {
                
                if let first = weekdays.first {
                    
                    weekdays.append(first)
                    
                    weekdays.removeFirst()
                    
                }
                
            }
            
        }
        
        return weekdays.map { $0.capitalized }
        
    }
    
    
    
    var startOfMonth: Date {
        
        Calendar.current.dateInterval(of: .month, for: self)!.start
        
    }
    
    
    
    var endOfMonth: Date {
        
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
        
    }
    
    
    
    var numberOfDaysInMonth: Int {
        
        Calendar.current.component(.day, from: endOfMonth)
        
    }
    
    
    
    var firstWeekDayBeforeStart: Date {
        
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        
        var numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek
        
        if numberFromPreviousMonth < 0 {
            
            numberFromPreviousMonth += 7 // Adjust to a 0-6 range if negative
            
        }
        
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
        
    }
    
    
    
    var calendarDisplayDays: [Date] {
        
        var days: [Date] = []
        
        // Start with days from the previous month to fill the grid
        
        let firstDisplayDay = firstWeekDayBeforeStart
        
        var day = firstDisplayDay
        
        while day < startOfMonth {
            
            days.append(day)
            
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
            
        }
        
        // Add days of the current month
        
        for dayOffset in 0..<numberOfDaysInMonth {
            
            if let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth) {
                
                days.append(newDay)
                
            }
            
        }
        
        return days
        
    }
    
    
    
    var monthInt: Int {
        
        Calendar.current.component(.month, from: self)
        
    }
    
    
    
    var startOfDay: Date {
        
        Calendar.current.startOfDay(for: self)
        
    }
    
    
    
    var hourInt: Int {
        
        Calendar.current.component(.hour, from: self)
        
    }
    
    
    
    var minuteInt: Int {
        
        Calendar.current.component(.minute, from: self)
        
    }
    
    
    
    var formattedDate: String {
        
        let formatter = ISO8601DateFormatter()
        
        formatter.timeZone = .current
        
        formatter.formatOptions = [.withFullDate]
        
        return formatter.string(from: self)
        
    }
    
    
    
    var formattedDateHourCombined: String {
        
        let formatter = ISO8601DateFormatter()
        
        formatter.timeZone = .current
        
        return formatter.string(from: self)
        
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
    
    @State private var notificationsEnabled = false
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                
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
                    
                    // Name and Join Date
                    VStack(spacing: 5) {
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.currentTheme.textColor)
                        Text("Joined: " + user.joinDate)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    
                    // Personal Info Display
                    VStack(spacing: 0) {
                        Text("Bio")
                            .frame(maxWidth: 360, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(spacing: 0) {
                            ProfileInfoRow(icon: "person.fill", title: "About", value: user.bio)
                            ProfileInfoRow(icon: "bubble.right.fill", title: "Quote", value: user.quote)
                        }
                        .background(themeManager.currentTheme.cardColor)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                        
                        Spacer()
                        Text("Personal Information")
                            .frame(maxWidth: 360, alignment: .leading)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(spacing: 0) {
                            ProfileInfoRow(icon: "person.fill", title: "Username", value: user.userName)
                            ProfileInfoRow(icon: "envelope.fill", title: "Email", value: user.email)
                            ProfileInfoRow(icon: "phone.fill", title: "Phone", value: user.phoneNumber)
                            ProfileInfoRow(icon: "calendar", title: "Birthday", value: user.bday)
                        }
                        .background(themeManager.currentTheme.cardColor)
                        .cornerRadius(15)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Theme selection (buttons)
                    ThemeSelectionView()
                        .padding(.top, 20)
                }
            }
            .navigationBarItems(trailing:
                                    Button("Edit Profile") {
                showingEditProfile = true
            }
                .foregroundColor(themeManager.currentTheme.editProfileColor)
            )
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: $user)
                    .environmentObject(themeManager)
            }
            .background(themeManager.currentTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .foregroundColor(themeManager.currentTheme.textColor)
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
                .navigationBarItems(leading:
                                        Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                                    trailing:
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
                )
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
    
    // MARK: - UserProfile
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
            .foregroundColor(themeManager.currentTheme.textColor)
        }
    }
}

// MARK: - Theme selection view (buttons)
struct ThemeSelectionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Theme:")
                .font(.title2.weight(.bold))
                .foregroundColor(themeManager.currentTheme.textColor)
            
            HStack(spacing: 20) {
                themeButton(.light, color: .white)
                themeButton(.dark, color: .black)
                themeButton(.ocean, color: .blue)
                themeButton(.sunset, color: .orange)
            }
        }
        .padding()
    }
    
    func themeButton(_ theme: Theme, color: Color) -> some View {
        Button {
            themeManager.currentTheme = theme
        } label: {
            Circle()
                .fill(color)
                .frame(width: 55, height: 55)
                .overlay(
                    Circle()
                        .stroke(themeManager.currentTheme == theme ? themeManager.currentTheme.accentColor : Color.clear, lineWidth: 4)
                )
                .shadow(radius: 4)
        }
    }
}

// This is for the change of the color of the Dashboard title respective to the theme!
struct NavigationBarColor: ViewModifier {
    var textColor: UIColor
    
    init(textColor: UIColor) {
        self.textColor = textColor
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: textColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBarTextColor(_ color: Color) -> some View {
        self.modifier(NavigationBarColor(textColor: UIColor(color)))
    }
}
