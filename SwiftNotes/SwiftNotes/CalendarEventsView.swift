import SwiftUI

struct CalendarEventsView: View {
    @Binding var showingCalendarView: Bool
    @State private var currentDate = Date()
    @State private var events: [Date: [(String, PriorityLevel)]] = [:]
    @State private var selectedDate: Date? = nil

    var notes: [Note]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack {
                    // Header with month and year navigation
                    HStack {
                        Button(action: { changeMonth(by: -1) }) {
                            Image(systemName: "chevron.left")
                        }
                        Text(monthYearFormatter.string(from: currentDate))
                            .font(.headline)
                        Button(action: { changeMonth(by: 1) }) {
                            Image(systemName: "chevron.right")
                        }
                    }
                    .padding(.vertical, 10)

                    // Days of the week
                    HStack {
                        ForEach(dayAbbreviations, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }

                    // Calendar grid
                    let days = generateDays(for: currentDate)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                        ForEach(days, id: \.self) { day in
                            VStack {
                                if day.monthMatch {
                                    Text("\(day.number)")
                                        .foregroundColor(day.isToday ? .red : .primary)
                                        .onTapGesture {
                                            selectedDate = day.date
                                        }
                                    Circle()
                                        .fill(dayBackground(day.date))
                                        .frame(width: 5, height: 5)
                                        .padding(.top, 4)
                                } else {
                                    Text("")
                                }
                            }
                            .frame(height: 40)
                        }
                    }
                    .padding(.bottom, 10)
                }

                Divider()

                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if let selectedDate = selectedDate, let dayEvents = events[selectedDate] {
                            Text("Events for \(monthYearFormatter.string(from: selectedDate))")
                            ForEach(dayEvents, id: \.0) { (title, priority) in
                                Text("• \(title) - \(priority.rawValue)")
                                    .foregroundColor(priority.color())
                            }
                        } else {
                            Text("No events for this date")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                loadEventsFromNotes()
            }
            .navigationTitle("Calendar Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                }
            }
        }
    }

    private func loadEventsFromNotes() {
        events.removeAll()
        for note in notes {
            guard let deadline = note.deadline else { continue }
            let eventDate = Calendar.current.startOfDay(for: deadline)
            events[eventDate, default: []].append((note.title, note.priority))
        }
    }

    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    private func generateDays(for date: Date) -> [Day] {
        var days = [Day]()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!

        let weekdayOffset = calendar.component(.weekday, from: startOfMonth) - calendar.firstWeekday
        for day in 1..<(range.count + weekdayOffset) {
            let dayNumber = day - weekdayOffset
            let dayDate = calendar.date(byAdding: .day, value: dayNumber - 1, to: startOfMonth)
            days.append(Day(number: dayNumber, date: dayDate ?? startOfMonth, isToday: calendar.isDateInToday(dayDate ?? startOfMonth), monthMatch: dayNumber > 0))
        }
        return days
    }

    private func dayBackground(_ date: Date) -> Color {
        guard let dayEvents = events[date] else { return Color.clear }
        let highestPriority = dayEvents.map { $0.1 }.sorted { $0.rawValue < $1.rawValue }.first
        return highestPriority?.color() ?? Color.clear
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

struct Day: Hashable {
    let number: Int
    let date: Date
    let isToday: Bool
    let monthMatch: Bool
}

let dayAbbreviations = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
