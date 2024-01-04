//
//  ContentView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			ForYouView()
				.tabItem { Label("For You", systemImage: "books.vertical.fill") }
			
			SearchView()
				.tabItem { Label("Search", systemImage: "doc.text.magnifyingglass") }
			
			ToReadView()
				.tabItem { Label("To read", systemImage: "book.fill") }
			
			FinishedView()
				.tabItem { Label("Finished", systemImage: "book.closed.fill") }
		}
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
			.previewDisplayName("iPhone 15 Pro")
		
		ContentView()
			.previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
			.previewDisplayName("iPhone 15 Pro Max")
		
		ContentView()
			.previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
			.previewDisplayName("iPhone SE")
	}
}
