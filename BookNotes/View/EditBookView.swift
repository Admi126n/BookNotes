//
//  EditBookView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 25/02/2024.
//

import SwiftData
import SwiftUI

struct EditBookView: View {
	@Binding var book: Book
	@Environment(\.dismiss) var dismiss
	@State private var authors: String
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Title") {
					TextField("Title", text: $book.title)
				}
				
				Section("Author") {
					TextField("Author", text: $authors)
				}
				
				// Cover
				
				// Categories
				
				if book.isFinished {
					Section("Rating") {
						RatingView(rating: $book.rating)
					}
				}
			}
			.toolbar {
				Button("Done") {
					dismiss()
				}
			}
			.onChange(of: authors) {
				book.setAuthors(authors)
			}
		}
	}
	
	init(book: Binding<Book>) {
		self._book = book
		self._authors = State(initialValue: book.wrappedValue.joinedAuthors)
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		let book = Book(title: "Example", authors: "Example authors")
		
		return EditBookView(book: .constant(book))
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
