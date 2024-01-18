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
	@FocusState var textEditorFocused: Bool
	@State var book: Book
	@State private var showingSheet = false
	@State private var renderedImage = Image(systemName: "book")
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				Text(book.title)
					.font(.largeTitle)
					.fontDesign(.serif)
					.bold()
				
				HStack {
					Text("by \(book.author)")
					
					Spacer()
					
					Text(book.genre)
				}
				.foregroundStyle(.secondary)
				.font(.headline)
				.padding(.bottom, 20)
				
				Text("Notes")
					.font(.headline)
				
				TextEditor(text: $book.notes)
					.scrollContentBackground(.hidden)
					.background(.textEditorBackground)
					.clipShape(.rect(cornerRadius: 10))
					.focused($textEditorFocused)
				
				HStack {
					Spacer()
					
					if book.isFinished {
						VStack {
							RatingView(rating: .constant(book.rating))
							
							Text("Finished on \(book.finishDate!.formatted(date: .abbreviated, time: .omitted))")
						}
					} else {
						Button("Mark as finished") {
							showingSheet = true
						}
						.buttonStyle(.borderedProminent)
					}
					
					Spacer()
				}
			}
			.padding()
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
				
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					
					Button("Done") {
						textEditorFocused = false
					}
				}
			}
			.sheet(isPresented: $showingSheet) {
				MarkAsFinishedView(book: book)
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
		
		let book = Book(title: "Example", author: "Example", genre: .scienceFiction)
		
		return DetailView(of: book)
			.modelContainer(container)
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
