//
//  SearchView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// List of all books
///
/// Finished books are marked with green checkmark. View has search bar with Google Books API searching
struct SearchView: View {
	
	@Query var books: [Book]
	
	@State private var searchText = ""
	
	@StateObject var vm = ViewModel()
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredBooks.isEmpty && vm.fetchedBooks.isEmpty && !vm.gettingResults {
					ContentUnavailableView("There are no books", systemImage: "book")
				} else {
					List {
						if !filteredBooks.isEmpty {
							Section("Your books") {
								ForEach(filteredBooks) { book in
									NavigationLink {
										DetailView(book: book)
									} label: {
										HStack {
											CellView(of: book)
											
											if book.isFinished {
												Spacer()
												
												Image(systemName: "checkmark")
													.foregroundStyle(.green)
											}
										}
									}
								}
							}
						}
						
						if !vm.fetchedBooks.isEmpty || vm.gettingResults {
							Section("Books from Google search") {
								ForEach(vm.fetchedBooks, id: \.self) { book in
									NavigationLink {
										DetailViewAPI(book: book, bookInCollection: checkIfBooksContains(book))
									} label: {
										CellView(of: book)
									}
								}
								
								if vm.gettingResults {
									ProgressView()
								}
							}
						}
					}
				}
			}			
			.searchable(
				text: $searchText,
				placement: .navigationBarDrawer(displayMode: .always),
				prompt: "Search for a title, author or category"
			)
			.onChange(of: searchText) {
				if searchText.isEmpty {
					vm.clearFetchedBooks()
				}
			}
			.navigationTitle("Search")
			.onSubmit(of: .search) {
				vm.clearFetchedBooks()
				vm.performRequest(for: searchText)
			}
		}
	}
}

// MARK: - Computed properties

extension SearchView {
	
	/// Books filtered by `searchText`
	var filteredBooks: [Book] {
		books.filter {
			if searchText.isEmpty {
				return true
			} else {
				return $0.containsInTitle(searchText)
				|| $0.containsInAuthors(searchText)
				|| $0.containsInCategories(searchText)
			}
		}
	}
}

// MARK: - Methods

extension SearchView {

	/// Checks if given book is saved in user data
	/// - Parameter book: books to check
	/// - Returns: `true` if given book is saved in user data, `false` otherwise
	private func checkIfBooksContains(_ book: APIBook) -> Bool {
		let newBook = Book(book)
		
		return books.contains(newBook)
	}
}

#Preview {
	SearchView()
}
