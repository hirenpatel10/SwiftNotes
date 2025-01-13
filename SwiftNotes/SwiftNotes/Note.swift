//
//  Note.swift
//  SwiftNotes
//
//  Created by Hiren Patel on 2024-11-03.
//
import SwiftData
import Foundation

@Model
final class Note: Identifiable {
    var title: String
    var noteDescription: String
    private var priorityRaw: String
    var timestamp: Date?
    var deadline: Date?

    init(title: String = "", noteDescription: String = "", priority: PriorityLevel = .medium, timestamp: Date? = nil, deadline: Date? = nil) {
        self.title = title
        self.noteDescription = noteDescription
        self.priorityRaw = priority.rawValue
        self.timestamp = timestamp
        self.deadline = deadline
    }

    var priority: PriorityLevel {
        get {
            PriorityLevel(rawValue: priorityRaw) ?? .medium
        }
        set {
            priorityRaw = newValue.rawValue
        }
    }
}
