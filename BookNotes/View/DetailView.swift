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
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var favourites: Favourites
	@FocusState var textEditorFocused: Bool
	@State var book: Book
	@State private var showingSheet = false
	@State private var renderedImage = Image(systemName: "book")
	
	var body: some View {
		GeometryReader { geo in
			ScrollView {
				VStack(alignment: .leading) {
					HStack {
						VStack(alignment: .leading) {
							TitleView(book)
							
							AuthorsView(book)
							
							Spacer()
							
							CategoriesView(book)
						}
						
						Spacer()
						
						if let imageData = book.imageData, let image = UIImage(data: imageData) {
							CoverImageView(image)
								.frame(width: geo.frame(in: .global).width / 3)
						}
					}
					
					Divider()
					
					HStack {
						Text("Notes")
							.font(.headline)
						
						if favourites.contains(book) {
							Spacer()
							
							Image(systemName: "heart.fill")
								.foregroundStyle(.red)
						}
					}
					
					TextEditor(text: $book.notes)
						.scrollContentBackground(.hidden)
						.background(.textEditorBackground)
						.clipShape(.rect(cornerRadius: 10))
						.focused($textEditorFocused)
						.frame(height: 200)
					
					HStack {
						Spacer()
						
						if book.isFinished {
							VStack {
								RatingView(rating: .constant(book.rating))
									.padding(.bottom, 1)
								
								Text("Finished on \(book.safeFinishDate.formatted(date: .abbreviated, time: .omitted))")
							}
						} else {
							Button("Mark as finished") {
								showingSheet = true
							}
							.buttonStyle(.borderedProminent)
						}
						
						Spacer()
					}
					.padding(.vertical)
				}
				.padding(.horizontal)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.navigationBarTitleDisplayMode(.inline)
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
				MarkAsFinishedView(book: $book) {
					dismiss()
				}
			}
			.onAppear {
				getSharedImage()
			}
		}
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
		
		let book = Book(title: "Example", authors: "Example")
		
		return DetailView(book: book)
			.modelContainer(container)
			.environmentObject(Favourites())
	} catch {
		return Text("Failed to create container, \(error.localizedDescription)")
	}
}
