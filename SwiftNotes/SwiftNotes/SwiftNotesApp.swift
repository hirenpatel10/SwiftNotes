//
//  NoteRow.swift
//  SwiftNotes
//
//  Created by Hiren Patel on 2024-11-03.
//

import SwiftUI
import SwiftData

@main
struct SwiftNotesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: Note.self)
        }
    }
}
