//
//  FinishedView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// List of all finished books with favourites marked.
struct FinishedView: View {
	@Query var books: [Book]
	
	var filteredBooks: [Book] {
		books.filter { $0.finished }
	}
	
    var body: some View {
		NavigationStack {
			List(filteredBooks) { book in
				NavigationLink {
					DetailView(of: book)
				} label: {
					VStack(alignment: .leading) {
						Text(book.title)
							.fontDesign(.serif)
						
						Text(book.author)
							.font(.caption)
					}
				}
			}
			.navigationTitle("Finished")
		}
    }
}

#Preview {
    FinishedView()
}
