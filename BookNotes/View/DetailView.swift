//
//  DetailView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftData
import SwiftUI

/// Book detail view.
struct DetailView: View {
	@Bindable var book: Book
	
    var body: some View {
		VStack {
			Text(book.title)
				.font(.title)
			
			Text(book.author)
			
			if !book.finished {
				Toggle("Is finished", isOn: $book.finished)
					.padding()
			}
		}
    }
	
	init(of book: Book) {
		self.book = book
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: Book.self, configurations: config)
		
		let book = Book(title: "Example", author: "Example", genre: "fantasy", finished: false)
		
		return DetailView(of: book)
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
