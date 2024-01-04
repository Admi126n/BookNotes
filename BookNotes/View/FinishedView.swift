//
//  FinishedView.swift
//  BookNotes
//
//  Created by Adam Tokarski on 04/01/2024.
//

import SwiftUI

/// List of all finished books with favourites marked.
struct FinishedView: View {
    var body: some View {
		VStack {
			Text("Finished")
				.italic()
				.padding()
			
			Image(systemName: "book.closed")
				.font(.title)
		}
    }
}

#Preview {
    FinishedView()
}
