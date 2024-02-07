//
//  SearchView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// Listed books based on user search input (provided by Google Books API).
struct SearchView: View {
	@Query var books: [Book]
	@State private var searchText = ""
	@State private var fetchedBooks: [APIBook] = []
	@State private var gettingResults = false
	@StateObject var networkMonitor = NetworkMonitor()
	
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
	
	var body: some View {
		NavigationStack {
			Group {
				if filteredBooks.isEmpty && fetchedBooks.isEmpty && !gettingResults {
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
						
						if !fetchedBooks.isEmpty || gettingResults {
							Section("Books from Google search") {
								ForEach(fetchedBooks, id: \.self) { book in
									NavigationLink {
										DetailViewAPI(book: book, bookInCollection: checkIfBooksContains(book))
									} label: {
										CellView(of: book)
									}
								}
								
								if gettingResults {
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
				prompt: "Search for a title, author or genre"
			)
			.onChange(of: searchText) {
				if searchText.isEmpty {
					clearResults()
				}
			}
			.navigationTitle("Search")
			.onSubmit(of: .search) {
				withAnimation {
					fetchedBooks = []
				}
				performRequest()
			}
		}
	}
	
	private func checkIfBooksContains(_ book: APIBook) -> Bool {
		let newBook = Book(title: book.title, authors: book.authors)
		
		return books.contains(newBook)
	}
	
	private func performRequest() {
		if !networkMonitor.isConnected { return }
		
		Task {
			withAnimation {
				gettingResults = true
			}
			
			let results = await APIConnector.getApiResults(for: searchText)
			
			Task { @MainActor in
				withAnimation {
					gettingResults = false
					fetchedBooks = results
				}
			}
		}
	}
	
	private func clearResults() {
		withAnimation {
			fetchedBooks = []
		}
	}
}

#Preview {
	SearchView()
}
