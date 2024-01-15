//
//  BookListView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 14/01/2024.
//

import SwiftData
import SwiftUI

struct BooksListView: View {
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var favourites: Favourites
	@Query var books: [Book]
	
	var body: some View {
		if books.count == 0 {
			ContentUnavailableView("There are no books", systemImage: "book")
		} else {
			List {
				ForEach(books) { book in
					NavigationLink {
						DetailView(of: book)
					} label: {
						CellView(of: book)
					}
					.swipeActions(edge: .trailing, allowsFullSwipe: true) {
						DeleteButton {
							modelContext.delete(book)
							favourites.remove(book)
						}
					}
					.swipeActions(edge: .leading, allowsFullSwipe: true) {
						if favourites.contains(book) {
							RemoveFromFavouritesButton {
								favourites.remove(book)
							}
						} else {
							AddToFavouritesButton {
								favourites.add(book)
							}
						}
					}
				}
			}
		}
	}
	
	init(sort: SortDescriptor<Book>, searchText: String, _ finished: Bool? = nil) {
		_books = Query(filter: #Predicate { book in
			if searchText.isEmpty {
				if let finished = finished {
					return book.isFinished == finished
				} else {
					return true
				}
			} else {
				if let finished = finished {
					return book.isFinished == finished
					&& (book.title.localizedStandardContains(searchText)
					|| book.author.localizedStandardContains(searchText)
						|| book.genre.localizedStandardContains(searchText))
				} else {
					return book.title.localizedStandardContains(searchText)
					|| book.author.localizedStandardContains(searchText)
				}
			}
		}, sort: [sort])
	}
}

//#Preview {
//	do {
//		let config = ModelConfiguration(isStoredInMemoryOnly: true)
//		let container = try ModelContainer(for: Book.self, configurations: config)
//
//		return BookListView(sort: SortDescriptor(\Book.title), searchText: "")
//			.modelContainer(container)
//			.environmentObject(Favourites())
//	} catch {
//		return Text("Failed to create container, \(error.localizedDescription)")
//	}
//}
