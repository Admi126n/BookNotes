//
//  SuggestionsList.swift
//  BookNotes
//
//  Created by Adam Tokarski on 19/02/2024.
//

import SwiftData
import SwiftUI

struct SuggestionsListView: View {
	@EnvironmentObject var favourites: Favourites
	@Query var books: [Book]
	@State private var fetchedBooks: [APIBook] = []
	@State private var gettingResults = false
	@StateObject var networkMonitor = NetworkMonitor()
	
	var filteredResults: [APIBook] {
		fetchedBooks.filter { book in
			let b = Book(book)
			
			return !books.contains(b)
		}
	}
	
	var body: some View {
		Group {
			if fetchedBooks.isEmpty && favourites.count == 0 {
				HStack {
					Text("Mark books as favourite to get some suggestions")
						.font(.title2)
						.bold()
						.padding(.leading, 5)
					
					Spacer()
				}
			} else {
				VStack(alignment: .leading) {
					Divider()
					
					Text("Similar to your favourites")
						.font(.title2)
						.bold()
						.padding(.leading, 5)
						.padding(.bottom, 5)
					
					ScrollView(.horizontal) {
						HStack {
							ForEach(filteredResults, id: \.self) { book in
								NavigationLink {
									DetailViewAPI(book: book, bookInCollection: false)
								} label: {
									HorizontalScrollViewCell(book)
										.padding(.horizontal, 5)
										.tint(.primary)
								}
							}
						}
						.scrollTargetLayout()
					}
					.scrollTargetBehavior(.viewAligned)
					.scrollIndicators(.hidden)
				}
			}
		}
		.onChange(of: networkMonitor.isConnected) { _, newValue in
			if newValue {
				performRequest()
			}
		}
		.onChange(of: favourites.count) { _, newValue in
			if newValue == 0 {
				fetchedBooks = []
			}
		}
		.onAppear(perform: performRequest)
	}
	
	private func performRequest() {
		guard networkMonitor.isConnected else { return }
		
		for (i, title) in favourites.favouriteAuthors.enumerated() {
			Task {
				let results = await APIConnector.getApiResults(for: title, .author)
				Task { @MainActor in
					withAnimation {
						if i == 0 {
							fetchedBooks = results
						} else {
							fetchedBooks.append(contentsOf: results)
						}
					}
				}
			}
		}
	}
}

#Preview {
	SuggestionsListView()
}
