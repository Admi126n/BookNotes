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
	@State private var showingSheet = false
	
	var filteredBooks: [Book] {
		books.filter { !$0.finished }
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(filteredBooks) { book in
					NavigationLink(book.title) {
						DetailView(of: book)
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
						showingSheet = true
					}
				}
			}
			.sheet(isPresented: $showingSheet) {
				AddBookView()
			}
		}
    }
	
	private func removeBook(_ indexSet: IndexSet) {
		for index in indexSet {
			let book = books[index]
			modelContext.delete(book)
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		return ToReadView()
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
