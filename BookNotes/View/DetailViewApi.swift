//
//  DetailViewApi.swift
//  BookNotes
//
//  Created by Adam Tokarski on 23/01/2024.
//

import SwiftUI

struct DetailViewApi: View {
	@Environment(\.modelContext) var modelContext
	@State private var imageData: Data?
	let book: APIBook
	
	var body: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 20) {
					HStack {
						if let imageLink = book.imageLink {
							AsyncImage(url: imageLink) {
								$0
							} placeholder: {
								ProgressView()
							}
						}
						
						VStack(alignment: .leading) {
							Text(book.title)
								.font(.largeTitle)
								.fontDesign(.serif)
								.bold()
							
							Text(book.authors, format: .list(type: .and))
								.foregroundStyle(.secondary)
								.font(.headline)
							
							if let price = book.price {
								Text("\(price.amount, specifier: "%.2f") \(price.currency)")
							}
							
							Spacer()
						}
					}
					
					if let categories = book.categories {
						Text(categories, format: .list(type: .and))
					}
					
					if let subtitle = book.subtitle {
						Text(subtitle)
					}
					
					if let description = book.description {
						Text(description)
					}
					
					if let rating = book.averageRating {
						HStack {
							Text("Average rating: ")
							
							RatingView(rating: .constant(Int(rating)))
						}
					}
					
					HStack {
						Button("Add to wanted books") {
							addToRead(book)
						}
						
						Button("Add to finished books") {
							
						}
						.disabled(true)
					}
					.buttonStyle(.borderedProminent)
				}
				.padding(.horizontal)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.task {
				// TODO: - move to view model
				if let imageLink = book.imageLink {
					imageData = await APIConnector.getImageData(from: imageLink)
				}
			}
		}
	}
	
	// TODO: - move to view model
	private func addToRead(_ book: APIBook) {
		let newBook = Book(title: book.title, author: book.authors.joined(separator: ", "), genre: .other)
		
		if let genres = book.categories {
			newBook.genre = genres.joined(separator: ", ")
		}
		
		if let subtitle = book.subtitle {
			newBook.notes = subtitle
		}
		
		if let data = imageData {
			newBook.set(image: data)
		}
		
		modelContext.insert(newBook)
	}
}

#Preview {
	DetailViewApi(book: APIBook.example)
}
