//
//  DetailViewApi.swift
//  BookNotes
//
//  Created by Adam Tokarski on 23/01/2024.
//

import SwiftUI

struct DetailViewApi: View {
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
							
						}
						
						Button("Add to finished books") {
							
						}
					}
					.buttonStyle(.borderedProminent)
					.disabled(true)
				}
				.padding(.horizontal)
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
}

#Preview {
	DetailViewApi(book: APIBook.example)
}
