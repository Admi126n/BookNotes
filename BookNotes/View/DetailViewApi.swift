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
						VStack(alignment: .leading) {
							Title(book)
							
							Authors(book)
							
							if let price = book.price {
								Text("\(price.amount, specifier: "%.2f") \(price.currency)")
							}
							
							Spacer()
						}
						
						Spacer()
						
						if let imageLink = book.imageLink {
							AsyncImage(url: imageLink, transaction: .init(animation: .easeIn)) { phase in
								switch phase {
								case .empty:
									ProgressView()
								case .success(let image):
									image
								case .failure(_):
									Image(systemName: "book.closed")
								@unknown default:
									Image(systemName: "book.closed")
								}
							}
						}
					}
					
					Categories(book)
					
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
					}
					
					if let description = book.description {
						Text(description)
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
		
		newBook.categories = book.categories.sorted()
		
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
