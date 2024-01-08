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
	@State var book: Book
	@State private var showingSheet = false
	@State private var renderedImage = Image(systemName: "book")
	
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				
				Text(book.title)
					.font(.title)
				
				Text(book.author)
				
				Spacer()
				
				if !book.finished {
					Button("Mark as finished") {
						showingSheet = true
					}
					.buttonStyle(.borderedProminent)
					.padding()
				}
			}
			
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					ShareLink(
						"Share",
						item: renderedImage,
						message: Text("Check out this book!"),
						preview: SharePreview(
							Text("My book"),
							icon: renderedImage
						)
					)
				}
			}
			.sheet(isPresented: $showingSheet) {
				MarkAsFinishedView(book: $book)
					.interactiveDismissDisabled()
			}
			.onAppear {
				getSharedImage()
			}
			.navigationBarTitleDisplayMode(.inline)
		}
	}
	
	init(of book: Book) {
		self.book = book
	}
	
	@MainActor func getSharedImage() {
		let sharedView = SharedView(of: book)
		if let safeImage = sharedView.render() {
			renderedImage = safeImage
		}
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
