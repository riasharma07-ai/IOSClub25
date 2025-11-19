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
// Nancy!

struct CalendarView: View {

    var onDateSelected: (Date) -> Void = { _ in }

    @State private var selectedDate = Date()

    

    var body: some View {

        NavigationStack {

            VStack(alignment: .center) {

                DatePicker(

                    "",

                    selection: $selectedDate,

                    displayedComponents: [.date]

                )

                .datePickerStyle(.graphical)

                .frame(maxWidth: .infinity, maxHeight: .infinity)

                .padding()

                

                Spacer()

                                

                Button("Confirm Date") {

                    onDateSelected(selectedDate)

                }

                .padding()

                                

                Spacer()

            }

            .navigationTitle("Calendar")

        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }

}



// with help of a tutorial to implement a basic calendar feature

struct ScheduleView: View {

    @State private var selectedSessionDate: Date = Date.now

    @State private var selectedSessionHour: Date = Date.now

    

    var onDateSelected: (Date) -> Void = { _ in }

    

    var body: some View {

        VStack(spacing: 10) {

            VStack {

                Text("Schedule View")

                    .font(.system(size: 20, weight: .semibold))

                    .foregroundStyle(.black)

                    .textCase(.uppercase)

            }

            

            CalendarView { mergedDate in

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

                        .foregroundStyle(.blue)

                        .padding()

                        .background(

                            Circle()

                                .stroke(.blue, lineWidth: 2)

                                .fill(.blue.opacity(0.1))

                        )

                }

            }

            Spacer()

        }

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





struct ProfileView: View {

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



extension Date {

    static var firstDayOfWeek = Calendar.current.firstWeekday

    

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
