//
//  MarkAsFinishedView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 06/01/2024.
//

import SwiftData
import SwiftUI

struct MarkAsFinishedView: View {
	@Environment(\.dismiss) var dismiss
	@FocusState var textEditorFocused: Bool
	@Binding var book: Book
	let onSaveAction: () -> Void
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Notes") {
					TextEditor(text: $book.notes)
						.focused($textEditorFocused)
				}
				
				Section("Book rating") {
					HStack {
						Spacer()
						RatingView(rating: $book.rating)
						Spacer()
					}
				}
			}
				
			.navigationTitle("Mark \(book.title) as finished")
			.toolbarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						book.markAsFinished()
						onSaveAction()
						dismiss()
					}
				}
				
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
				
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					
					Button("Done") {
						textEditorFocused = false
					}
				}
			}
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		let book = Book(title: "Example", author: "Example", genre: .other)
		
		return MarkAsFinishedView(book: .constant(book)) { }
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
