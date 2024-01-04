//
//  ForYouView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// Books propositions based on finished and favourite books (provided by Google Books API).
struct ForYouView: View {
    var body: some View {
		VStack {
			Text("For You")
				.italic()
				.padding()
			
			Image(systemName: "books.vertical")
				.font(.title)
		}
    }
}

#Preview {
    ForYouView()
}
