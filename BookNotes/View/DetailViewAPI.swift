//
//  DetailViewAPI.swift
//  BookNotes
//
//  Created by Adam Tokarski on 23/01/2024.
//

import SwiftUI

struct DetailViewAPI: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext
	@State private var imageData: Data?
	@State private var showingSheet = false
	@State private var showindDialog = false
	@State private var newBook = Book(title: "Example", authors: "Example")
	@StateObject private var c = Categories()
	let book: APIBook
	let bookInCollection: Bool
	
	var body: some View {
		GeometryReader { geo in
			ScrollView {
				VStack(alignment: .leading) {
					HStack {
						VStack(alignment: .leading) {
							TitleView(book)
							
							AuthorsView(book)
							
							if let price = book.price {
								Text("\(price.amount, specifier: "%.2f") \(price.currency)")
							}
							
							Spacer()
							
							CategoriesView(book)
						}
						
						Spacer()
						
						if let imageLink = book.imageLink {
							AsyncImage(url: imageLink, transaction: .init(animation: .easeIn)) { phase in
								switch phase {
								case .empty:
									ProgressView()
								case .success(let image):
									CoverImageView(image)
								case .failure(_):
									Image(systemName: "book.closed")
								@unknown default:
									Image(systemName: "book.closed")
								}
							}
							.frame(width: geo.frame(in: .global).width / 3)
						}
					}
					
					if let rating = book.averageRating {
						HStack {
							Text("Average rating")
							
							RatingView(rating: .constant(Int(rating)))
						}
					}
					
					Divider()
					
					if let subtitle = book.subtitle {
						Text(subtitle)
							.foregroundStyle(.secondary)
							.padding(.bottom)
					}
					
					if let description = book.description {
						DescriptionView(description)
					}
					
					if book.subtitle != nil || book.description != nil {
						Divider()
					}
					
					HStack {
						Spacer()
						
						if bookInCollection {
							Text("You already have this book")
								.font(.subheadline)
								.foregroundStyle(.secondary)
						} else {
							Button("Add book") {
								showindDialog = true
							}
							.buttonStyle(.bordered)
						}
						
						Spacer()
					}
				}
				.padding()
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.navigationBarTitleDisplayMode(.inline)
			.task {
				// TODO: - move to view model
				if let imageLink = book.imageLink {
					imageData = await APIConnector.getImageData(from: imageLink)
				}
			}
			.sheet(isPresented: $showingSheet) {
				MarkAsFinishedView(book: $newBook) {
					dismiss()
					modelContext.insert(newBook)
				}
			}
			.confirmationDialog("Add book", isPresented: $showindDialog) {
				Button("Add as wanted") {
					addToRead(book)
					dismiss()
				}
				
				Button("Add as finished") {
					addRead(book)
					showingSheet = true
				}
				
				Button("Cancel", role: .cancel) { }
			}
		}
	}
	
	// TODO: - move to view model
	private func addToRead(_ book: APIBook) {
		newBook = Book(book)
		
		newBook.setCategoreis(book.categories)
		
		if let subtitle = book.subtitle {
			newBook.notes = subtitle
		}
		
		if let data = imageData {
			newBook.setImageData(data)
		}
		
		c.add(book.categories)
		modelContext.insert(newBook)
	}
	
	private func addRead(_ book: APIBook) {
		newBook = Book(book)
		
		newBook.setCategoreis(book.categories)
		
		if let subtitle = book.subtitle {
			newBook.notes = subtitle
		}
		
		if let data = imageData {
			newBook.setImageData(data)
		}
		
		c.add(book.categories)
		newBook.markAsFinished()
	}
}

#Preview {
	DetailViewAPI(book: APIBook.example, bookInCollection: false)
}
