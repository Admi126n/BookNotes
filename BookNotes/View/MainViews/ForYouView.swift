//
//  ForYouView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI
import TipKit

/// Books propositions based on finished and favourite books (provided by Google Books API).
struct ForYouView: View {
	private let welcomeTip = WelcomeTip()
	private let favouritesTip = FavouritesTip()
	
	@State private var showingSheet = false
	
	var body: some View {
		NavigationStack {
			GeometryReader { geo in
				ScrollView {
					VStack {
						TipView(welcomeTip)
						
						BooksStatisticsView()
							.frame(height: geo.frame(in: .global).width * 0.6)
						
						FavouritesListView()
						
						SuggestionsListView()
						
						TipView(favouritesTip)
					}
					.toolbar {
						Button("Settings", systemImage: "person.crop.circle") {
							showingSheet = true
						}
					}
					.sheet(isPresented: $showingSheet) {
						SettingsView()
					}
				}
				.frame(width: geo.frame(in: .global).width)
			}
			.onTapGesture {
				welcomeTip.invalidate(reason: .actionPerformed)
				favouritesTip.invalidate(reason: .actionPerformed)
			}
		}
	}
}

#Preview {
    ForYouView()
		.environmentObject(Favourites())
}
