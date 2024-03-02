//
//  BookListView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 14/01/2024.
//

import SwiftData
import SwiftUI
import TipKit

fileprivate enum Tab {
	case search
	case toRead
	case finished
}

struct BooksListView: View {
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var favourites: Favourites
	@Query var books: [Book]
	private let addBooksTip = AddBooksTip()
	private var tab: Tab
	
	var body: some View {
		if books.count == 0 {
			VStack {
				if tab == .toRead {
					TipView(addBooksTip)
				}
				
				ContentUnavailableView("There are no books", systemImage: "book")
			}
		} else {
			List {
				ForEach(books) { book in
					NavigationLink {
						DetailView(book: book)
					} label: {
						HStack {
							CellView(of: book)
							
							if tab == .search, book.isFinished {
								Spacer()
								
								Image(systemName: "checkmark")
									.foregroundStyle(.green)
							}
						}
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
	
	init(sortAll by: SortDescriptor<Book>, search: String) {
		self.tab = .search
		
		_books = Query(filter: #Predicate { book in
			if search.isEmpty {
				return true
			} else {
				return book.title.contains(search)
				|| book.joinedAuthors.localizedStandardContains(search)
				|| book.joinedCategories.localizedStandardContains(search)
			}
		}, sort: [by])
	}
	
	init(sortFinished by: SortDescriptor<Book>, search: String) {
		self.tab = .finished
		
		_books = Query(filter: #Predicate { book in
			if search.isEmpty {
				return book.isFinished
			} else {
				return book.isFinished
				&& (book.title.localizedStandardContains(search)
				|| book.joinedAuthors.localizedStandardContains(search)
				|| book.joinedCategories.localizedStandardContains(search))
			}
		}, sort: [by])
	}
	
	init(sortUnfinished by: SortDescriptor<Book>, search: String) {
		self.tab = .toRead
		
		_books = Query(filter: #Predicate { book in
			if search.isEmpty {
				return !book.isFinished
			} else {
				return !book.isFinished
				&& (book.title.localizedStandardContains(search)
				|| book.joinedAuthors.localizedStandardContains(search)
				|| book.joinedCategories.localizedStandardContains(search))
			}
		}, sort: [by])
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
