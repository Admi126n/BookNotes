//
//  FavouritesListView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 18/02/2024.
//

import SwiftData
import SwiftUI

fileprivate struct HorizontalScrollViewCell: View {
	let book: Book
	
	var body: some View {
		ZStack {
			Color(.secondarySystemBackground)
			
			VStack {
				if let data = book.imageData {
					Image(uiImage: UIImage(data: data)!)
						.scaledToFit()
						.frame(width: 100, height: 150)
				} else {
					Spacer()
					
					Image(systemName: "text.book.closed")
						.font(.largeTitle)
				}
				
				Spacer()
				
				Text(book.title)
					.font(.headline)
					.fontDesign(.serif)
					.lineLimit(1)
			}
			.padding()
		}
		.frame(width: 150, height: 250)
		.clipShape(.rect(cornerRadius: 10))
	}
}

struct FavouritesListView: View {
	@EnvironmentObject var favourites: Favourites
	@Query var books: [Book]
	
    var body: some View {
		VStack(alignment: .leading) {
			Divider()
			
			Text("Your favourite books")
				.font(.title2)
				.bold()
				.padding(.leading, 5)
				.padding(.bottom, 5)
			
			if favourites.count == 0 {
				Text("You have no favourite books!")
					.padding(.leading, 5)
			} else {
				ScrollView(.horizontal) {
					HStack {
						ForEach(books) { book in
							if favourites.contains(book) {
								NavigationLink {
									DetailView(book: book)
								} label: {
									HorizontalScrollViewCell(book: book)
										.padding(.horizontal, 5)
										.tint(.primary)
								}
							}
						}
					}
					.scrollTargetLayout()
				}
				.scrollTargetBehavior(.viewAligned)
				.scrollIndicators(.hidden)
			}
		}
    }
}

#Preview {
    FavouritesListView()
		.environmentObject(Favourites())
}
