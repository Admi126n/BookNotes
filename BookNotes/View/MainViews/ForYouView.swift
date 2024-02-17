//
//  ForYouView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// Books propositions based on finished and favourite books (provided by Google Books API).
struct ForYouView: View {
	@State private var showingSheet = false
	
	var body: some View {
		NavigationStack {
			GeometryReader { geo in
				ScrollView {
					VStack {
						BooksStatisticsView()
							.frame(height: geo.frame(in: .global).width / 2)
						
						Text("For You")
							.italic()
							.padding()
						
						Image(systemName: "books.vertical")
							.font(.title)
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
		}
	}
}

#Preview {
    ForYouView()
		.environmentObject(Favourites())
}
