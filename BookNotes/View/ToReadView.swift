//
//  ToReadView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// List of books to read.
struct ToReadView: View {
	@Environment(\.modelContext) var modelContext
	@Query var books: [Book]
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(books) { book in
					NavigationLink(book.title) {
						DetailView(book: book)
					}
				}
				.onDelete(perform: removeBook)
				.swipeActions(edge: .leading, allowsFullSwipe: true) {
					Button {
						print("favourite")
					} label: {
						Label("favourite", systemImage: "star")
					}
					.tint(.yellow)
				}
			}
			.navigationTitle("To read")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Add book", systemImage: "plus") {
						addSample()
					}
				}
			}
		}
    }
	
	private func addSample() {
		modelContext.insert(Book(title: "1", author: "1", genre: "1", finished: false))
		modelContext.insert(Book(title: "2", author: "2", genre: "2", finished: true))
		modelContext.insert(Book(title: "3", author: "3", genre: "3", finished: false))
	}
	
	private func removeBook(_ indexSet: IndexSet) {
		for index in indexSet {
			let book = books[index]
			modelContext.delete(book)
		}
	}
}

#Preview {
    ToReadView()
}
