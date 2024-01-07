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
	@Binding var book: Book
	
	@State private var notes = ""
	@State private var rating = 2
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Notes for book") {
					TextEditor(text: $notes)
				}
				
				Section("Book rating") {
					Picker("Book rating", selection: $rating) {
						ForEach(1..<6) {
							Text("\($0)")
						}
					}
					.labelsHidden()
					.pickerStyle(.segmented)
				}
			}
			.navigationTitle("Mark \(book.title) as finished")
			.toolbarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						book.notes = notes
						book.rating = rating
						book.readDate = .now
						book.finished = true
						
						dismiss()
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
		
		let book = Book(title: "Example", author: "Example", genre: "fantasy", finished: false)
		
		return MarkAsFinishedView(book: .constant(book))
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
