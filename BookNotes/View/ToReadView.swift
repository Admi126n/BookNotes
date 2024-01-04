//
//  ToReadView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// List of books to read
struct ToReadView: View {
    var body: some View {
		VStack {
			Text("To read")
				.italic()
				.padding()
			
			Image(systemName: "book")
				.font(.title)
		}
    }
}

#Preview {
    ToReadView()
}
