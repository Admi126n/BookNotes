//
//  SearchView+ViewModel.swift
//  BookNotes
//
//  Created by Adam Tokarski on 16/03/2024.
//

import SwiftUI

extension SearchView {
	
	class ViewModel: ObservableObject {
		
		private var networkMonitor = NetworkMonitor()
		
		@Published private(set) var fetchedBooks: [APIBook] = []
		
		/// Set to `true` only during performing request to Google Books API
		@Published private(set) var gettingResults = false
		
		/// Performs request to Google Books API and sets `fetchedBooks`
		/// - Parameter searchText: query for Google Books API
		func performRequest(for searchText: String) {
			if !networkMonitor.isConnected { return }
			
			withAnimation {
				gettingResults = true
			}
			
			Task {
				let results = await APIConnector.getApiResults(for: searchText)
				
				Task { @MainActor in
					withAnimation {
						gettingResults = false
						fetchedBooks = results
					}
				}
			}
		}
		
		/// Sets `fetchedBooks` to empty array
		func clearFetchedBooks() {
			withAnimation {
				fetchedBooks = []
			}
		}
	}
}
