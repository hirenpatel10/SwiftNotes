import SwiftUI

struct NoteRow: View {
    var note: Note

    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.headline)
            Text(note.noteDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let deadline = note.deadline {
                Text("Deadline: \(deadline, formatter: DateFormatter.shortDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
