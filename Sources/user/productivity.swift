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
            
            CalendarView { date, hour in
                print("Selected date: \(date), hour: \(hour)")
            }
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
        "Hello! Ready to tackle the day?", "You're doing great, keep going!", "We're so proud of you, keep it up 😊", "Even small progress counts. Don't give up!"
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
                    Spacer()
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
                                    Text("Weekly Overview").font(.headline)
                                    HStack(alignment: .bottom, spacing: 8) {
                                            ForEach(weekData) { day in
                                                VStack {
                                                    Rectangle()
                                                        .fill(Color.blue)
                                                        .frame(width: 20, height: CGFloat(day.taskDone * 20)) // scale height
                                                    Text(day.day).font(.caption)
                                                }
                                            }
                                        }
                        
                    var averageTasks: Double {
                        let total = weekData.reduce(0) {$0 + $1.taskDone}
                        return Double(total) / Double(weekData.count)
                    }
                    Text("Try setting a goal for \(Int(averageTasks)) tasks per day.")
                        .italic()
                                    
                                    Divider()
                                    Spacer()
                                    
                                    // Quick Actions
                                    Text("Today’s Habits").font(.headline)
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
    @State private var currentMonth = Date.now
    @State private var selectedDate = Date.now
    @State private var selectedHour = Date.now
    @State private var days: [Date] = []

    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var onDateSelected: (Date, Date) -> Void

    var body: some View {
        NavigationView {
            VStack {
                Text("Calendar")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                // Month navigation
                HStack {
                    Text(currentMonth.formatted(.dateTime.year().month()))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                    Button {
                        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                        updateDays()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    Button {
                        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                        updateDays()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
                
                // Days of the week row
                HStack {
                    ForEach(daysOfWeek.indices, id: \.self) { index in
                        Text(daysOfWeek[index])
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Grid of days
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(days, id: \.self) { day in
                        Button {
                            if day >= Date.now.startOfDay && day.monthInt == currentMonth.monthInt {
                                selectedDate = day
                                onDateSelected(selectedDate, selectedHour)
                            }
                        } label: {
                            Text(day.formatted(.dateTime.day()))
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(foregroundStyle(for: day))
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundStyle(
                                            day.formattedDate == selectedDate.formattedDate
                                                ? .blue
                                                : .clear
                                        )
                                )
                        }
                        .disabled(day < Date.now.startOfDay || day.monthInt != currentMonth.monthInt)
                    }
                }
                
                // Time picker
                DatePicker(
                    "",
                    selection: $selectedHour,
                    displayedComponents: [.hourAndMinute]
                )
                .onChange(of: selectedHour) {
                    onDateSelected(selectedDate, selectedHour)
                }
                .datePickerStyle(.compact)
                .colorMultiply(.white)
                .environment(\.colorScheme, .dark)
            }
            .padding()
            .navigationTitle("Calendar")
            .onAppear {
                updateDays()
                onDateSelected(selectedDate, selectedHour)
            }
        }
    }
    
    private func updateDays() {
        days = currentMonth.calendarDisplayDays
    }
    
    private func foregroundStyle(for day: Date) -> Color {
        let isDifferentMonth = day.monthInt != currentMonth.monthInt
        let isSelectedDate = day.formattedDate == selectedDate.formattedDate
        let isPastDate = day < Date.now.startOfDay
        
        if isDifferentMonth {
            return isSelectedDate ? .black : .white.opacity(0.3)
        } else if isPastDate {
            return .white.opacity(0.3)
        } else {
            return isSelectedDate ? .black : .white
        }
    }
}


// Gavin S
struct ProfileView: View {
    @State private var isEditing = false

    // Default placeholder profile data
    @State private var fullName: String = "Your Name"
    @State private var username: String = "@username"
    @State private var email: String = "email@example.com"

    @State private var bio: String = "Write a short bio about yourself..."
    @State private var myWhy: String = "Add your favorite quote or motivation here."

    @State private var joinedDate: Date = Date()
    @State private var hasBirthday: Bool = false
    @State private var birthday: Date = Date()

    @State private var selectedTheme: AppTheme = .system

    var body: some View {
        NavigationView {
            Form {
                // PROFILE HEADER
                Section {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)

                        if isEditing {
                            TextField("Full Name", text: $fullName)
                                .multilineTextAlignment(.center)
                        } else {
                            Text(fullName)
                                .font(.headline)
                        }

                        if isEditing {
                            TextField("@username", text: $username)
                                .multilineTextAlignment(.center)
                        } else {
                            Text(username)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                // CONTACT
                Section(header: Text("Contact")) {
                    if isEditing {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    } else {
                        Text(email)
                    }
                }

                // DATES
                Section(header: Text("Details")) {
                    if isEditing {
                        DatePicker("Joined", selection: $joinedDate, displayedComponents: .date)
                    } else {
                        HStack {
                            Text("Joined")
                            Spacer()
                            Text(joinedDate, style: .date)
                                .foregroundColor(.secondary)
                        }
                    }

                    if isEditing {
                        Toggle("Show Birthday", isOn: $hasBirthday)
                        if hasBirthday {
                            DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
                        }
                    } else {
                        HStack {
                            Text("Birthday")
                            Spacer()
                            if hasBirthday {
                                Text(birthday, style: .date)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Not set")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                // BIO
                Section(header: Text("Bio")) {
                    if isEditing {
                        TextEditor(text: $bio)
                            .frame(minHeight: 80)
                    } else {
                        Text(bio)
                    }
                }

                // MY WHY / FAVORITE QUOTE
                Section(header: Text("My Why / Favorite Quote")) {
                    if isEditing {
                        TextEditor(text: $myWhy)
                            .frame(minHeight: 80)
                    } else {
                        Text("“\(myWhy)”")
                            .italic()
                    }
                }

                // THEME
                Section(header: Text("App Theme")) {
                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }
}