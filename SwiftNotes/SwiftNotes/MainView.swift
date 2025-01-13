//
//  MainView.swift
//  SwiftNotes
//
//  Created by Hiren Patel on 2024-11-03.
//


import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]
    @State private var showingCalendarView: Bool = false

    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            CalendarEventsView(showingCalendarView: $showingCalendarView, notes: notes)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}
