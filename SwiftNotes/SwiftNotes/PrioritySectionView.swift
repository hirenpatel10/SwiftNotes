//
//  PrioritySectionView.swift
//  SwiftNotes
//
//  Created by Hiren Patel on 2024-11-03.
//

import SwiftUI

struct PrioritySectionView: View {
    var title: String
    var color: Color
    var notes: [Note]
    var onDelete: (IndexSet) -> Void
    var onSave: (Note) -> Void // Pass the save action to allow updating

    var body: some View {
        Section(header: Text(title).foregroundColor(color)) {
            ForEach(notes) { note in
                NavigationLink(destination: NoteDetailView(isNew: false, note: note, onSave: onSave)) {
                    NoteRow(note: note)
                }
            }
            .onDelete(perform: onDelete)
        }
    }
}
