import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var notes: [Note]

    @State private var showingAddNote = false

    var body: some View {
        NavigationView {
            List {
                prioritySection(for: .high, color: .red)
                prioritySection(for: .medium, color: .orange)
                prioritySection(for: .low, color: .green)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddNote) {
                NoteDetailView(isNew: true, note: nil) { newNote in
                    modelContext.insert(newNote)
                    showingAddNote = false
                }
            }
            .onAppear {
                addSampleNotesIfNeeded()
            }
        }
    }

    // Helper function for creating each priority section
    private func prioritySection(for priority: PriorityLevel, color: Color) -> some View {
        let filteredNotes = notes.filter { $0.priority == priority }
        return PrioritySectionView(
            title: "\(priority.rawValue) Priority",
            color: color,
            notes: filteredNotes,
            onDelete: { indexSet in deleteNotes(at: indexSet, for: priority) },
            onSave: { updatedNote in
                modelContext.insert(updatedNote)
            }
        )
    }

    private func deleteNotes(at offsets: IndexSet, for priority: PriorityLevel) {
        let filteredNotes = notes.filter { $0.priority == priority }
        offsets.map { filteredNotes[$0] }.forEach { note in
            modelContext.delete(note)
        }
    }

    private func addSampleNotesIfNeeded() {
        guard notes.isEmpty else { return }
        
        let sampleNotes = [
            Note(
                title: "Meeting with Team",
                noteDescription: "Discuss project updates",
                priority: .high,
                timestamp: Date(),
                deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())
            ),
            Note(
                title: "Workout",
                noteDescription: "Go to the gym",
                priority: .medium,
                timestamp: Date(),
                deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date())
            ),
            Note(
                title: "Read Book",
                noteDescription: "Finish reading chapter 5",
                priority: .low,
                timestamp: Date(),
                deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date())
            )
        ]
        
        sampleNotes.forEach { modelContext.insert($0) }
    }
}
