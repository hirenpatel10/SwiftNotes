//
//  PriorityLevel.swift
//  SwiftNotes
//
//  Created by Hiren Patel on 2024-11-03.
//
import SwiftUI

enum PriorityLevel: String, CaseIterable, Identifiable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    var id: String { rawValue }

    func color() -> Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}
