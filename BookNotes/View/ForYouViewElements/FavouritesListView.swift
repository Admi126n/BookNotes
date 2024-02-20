//
//  FavouritesListView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 18/02/2024.
//

import SwiftData
import SwiftUI

struct FavouritesListView: View {
	@EnvironmentObject var favourites: Favourites
	@Query var books: [Book]
	
	var body: some View {
		if favourites.count == 0 {
			EmptyView()
		} else {
			VStack(alignment: .leading) {
				Divider()
				
				Text("Your favourite books")
					.font(.title2)
					.bold()
					.padding(.leading, 5)
					.padding(.bottom, 5)
				
				ScrollView(.horizontal) {
					HStack {
						ForEach(books) { book in
							if favourites.contains(book) {
								NavigationLink {
									DetailView(book: book)
								} label: {
									HorizontalScrollViewCell(book)
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
