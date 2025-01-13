import SwiftUI

struct NoteDetailView: View {
    var isNew: Bool
    var note: Note? // Make note optional to handle new and existing notes
    
    @State private var title: String = ""
    @State private var noteDescription: String = ""
    @State private var priority: PriorityLevel = .medium
    @State private var hasDeadline: Bool = false
    @State private var deadline: Date = Date()
    
    var onSave: (Note) -> Void // Closure to handle save action
    
    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter note title", text: $title)
                }
                
                Section(header: Text("Description")) {
                    TextField("Enter note description", text: $noteDescription)
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(PriorityLevel.allCases, id: \.self) { level in
                            Text(level.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Deadline")) {
                    Toggle("Has Deadline", isOn: $hasDeadline)
                    
                    if hasDeadline {
                        DatePicker("Deadline", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                        
                        Button("Set to End of Day") {
                            deadline = Calendar.current.startOfDay(for: deadline).addingTimeInterval(86399) // 11:59 PM of the selected day
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle(isNew ? "New Note" : "Edit Note")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss() // Dismiss the view without saving
                    }
                }
            }
            .onAppear {
                if let note = note, !isNew {
                    loadNoteDetails(from: note)
                }
            }
        }
    }
    
    private func saveNote() {
        if let note = note {
            // Update existing note
            note.title = title
            note.noteDescription = noteDescription
            note.priority = priority
            note.deadline = hasDeadline ? deadline : nil
        } else {
            // Create a new note if none exists
            let newNote = Note(
                title: title,
                noteDescription: noteDescription,
                priority: priority,
                timestamp: Date(),
                deadline: hasDeadline ? deadline : nil
            )
            onSave(newNote) // Save new note
        }
        
        dismiss() // Dismiss the view after saving
    }
    
    private func loadNoteDetails(from note: Note) {
        title = note.title
        noteDescription = note.noteDescription
        priority = note.priority
        if let noteDeadline = note.deadline {
            hasDeadline = true
            deadline = noteDeadline
        } else {
            hasDeadline = false
        }
    }
}
