//
//  RemoveFromFavouritesButton.swift
//  BookNotes
//
//  Created by Adam Tokarski on 07/01/2024.
//

import SwiftUI

struct RemoveFromFavouritesButton: View {
	let action: () -> Void
	
    var body: some View {
        Button("Remove from favourites", systemImage: "star.slash.fill", action: action)
			.tint(.gray)
    }
}

#Preview {
	RemoveFromFavouritesButton() {
		print("Removing from favourites...")
	}
}
