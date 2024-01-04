//
//  SearchView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// Listed books based on user search input (provided by Google Books API).
struct SearchView: View {
    var body: some View {
		VStack {
			Text("Search")
				.italic()
				.padding()
			
			Image(systemName: "doc.text.magnifyingglass")
				.font(.title)
		}
    }
}

#Preview {
    SearchView()
}
