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
	@State var book: Book
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Notes for book") {
					TextEditor(text: $book.notes)
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
		
		let book = Book(title: "Example", author: "Example", genre: "fantasy")
		
		return MarkAsFinishedView(book: book)
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
